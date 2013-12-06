class TestRunner
  SIPPYCUP_TARGET_PORT = "12345"
  BIND_IP = ENV['TEST_RUN_BIND_IP'] || "10.203.132.10"

  attr_accessor :stopped

  def initialize(test_run, job_id, ssh_password = nil)
    @test_run = test_run
    @jid = job_id
    @stopped = false
    @receiver_pid = nil
    @password = ssh_password
    @vmstat_buffer = []
    @receiver_port = Kernel.rand(5000...10000)
    @sender_port   = Kernel.rand(5000...10000)
  end

  def run
    execute_registration_scenario
    start_receiver_scenario

    @test_run.scenario.to_disk path, "scenario", source: "#{TestRunner::BIND_IP}:#{SIPPYCUP_TARGET_PORT}",
      destination: @test_run.target.address

    result = execute_runner

    unless @stopped
      parse_sipp_stats result[:stats_data]
      parse_rtcp_data result[:rtcp_data]
      parse_system_stats @vmstat_buffer if has_stats_credentials?
    end
  ensure
    halt_receiver_scenario
  end

  def stop
    @stopped = true
    @runner.stop
  end

  private

  def execute_registration_scenario
    return unless @test_run.registration_scenario

    @test_run.registration_scenario.to_disk path, "registration_scenario"

    options = {
      scenario: path("registration_scenario"),
      number_of_calls: 1,
      calls_per_second: 1,
      max_concurrent: 1,
      destination: @test_run.target.address,
      source: TestRunner::BIND_IP,
      source_port: @receiver_port,
      transport_mode: @test_run.profile.transport_type.to_s,
      full_sipp_output: false
    }
    options[:scenario_variables] = path("registration_scenario.csv") if @test_run.registration_scenario.csv_data.present?
    cup = SippyCup::Runner.new options
    cup.run
  end

  def start_receiver_scenario
    return unless @test_run.receiver_scenario

    @test_run.receiver_scenario.to_disk path, "receiver_scenario"

    command = "sipp -sf #{path('receiver_scenario.xml')} -i #{TestRunner::BIND_IP} -p #{@receiver_port}"
    command << " -inf #{path('receiver_scenario.csv')}" if @test_run.receiver_scenario.csv_data.present?
    command << " -t #{@test_run.profile.transport_type.to_s}" if @test_run.profile.transport_type.present?
    puts "Running receiver scenario using command #{command.inspect}"

    @receiver_pid = Process.spawn command, out: '/dev/null', err: '/dev/null'
  end

  def halt_receiver_scenario
    return unless @receiver_pid

    puts "Terminating receiver scenario..."

    Process.kill 'KILL', @receiver_pid

    @receiver_pid = nil
  rescue Errno::ESRCH
    puts "Could not stop the receiver scenario because it was not running"
  end

  def execute_runner
    runner_scenario = {
      scenario: path("scenario"),
      source: TestRunner::BIND_IP
    }

    runner_scenario[:scenario_variables] = path("scenario.csv") if @test_run.scenario.csv_data.present?

    runner_profile = {
      number_of_calls: @test_run.profile.max_calls,
      calls_per_second: @test_run.profile.calls_per_second,
      max_concurrent: @test_run.profile.max_concurrent,
      source_port: @sender_port,
      transport_mode: @test_run.profile.transport_type.to_s,
      vmstat_buffer: @vmstat_buffer
    }

    runner_target = {
      destination: @test_run.target.address
    }

    if has_stats_credentials?
      runner_target[:password] = @password
      runner_target[:username] = @test_run.target.ssh_username
    end

    @runner = Runner.new runner_name, runner_scenario, runner_profile, runner_target
    @runner.run
  end

  def path(suffix = '')
    File.join "/tmp", @jid, suffix
  end

  def runner_name
    @test_run.name.downcase.gsub(/\W/, '')
  end

  def parse_sipp_stats(stats)
    return unless stats
    SippParser.new(stats, @test_run).run
  end

  def parse_rtcp_data(data)
    return unless data
    RtcpParser.new(data, @test_run).run
  end

  def parse_system_stats(buffer)
    return unless buffer
    VMStatParser.new(buffer, @test_run).parse
  end

  def has_stats_credentials?
    @test_run.target.ssh_username.present? && !@password.nil?
  end
end
