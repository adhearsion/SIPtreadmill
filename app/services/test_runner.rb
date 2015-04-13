require 'tempfile'

class TestRunner
  BIND_IP = ENV['TEST_RUN_BIND_IP']

  attr_accessor :stopped

  def initialize(test_run, job_id, ssh_password = nil)
    @test_run = test_run
    @jid = job_id
    @stopped = false
    @receiver_runner = nil
    @receiver_error = nil
    @password = ssh_password
    @vmstat_buffer = []
    @csv_files = []
  end

  def run
    execute_registration_scenario
    start_receiver_scenario

    result = execute_runner

    unless @stopped
      parse_sipp_stats result[:stats_data]
      parse_rtcp_data result[:rtcp_data]
      parse_system_stats @vmstat_buffer if has_stats_credentials?
    end

    @test_run.summary_report = result[:summary_report]
    @test_run.errors_report_file = result[:errors_report_file]
    @test_run.stats_file = result[:stats_file]
    @test_run.save!
  ensure
    halt_receiver_scenario
    close_csv_files
  end

  def stop
    @stopped = true
    @runner.stop
  end

  private

  def execute_registration_scenario
    return unless @test_run.registration_scenario

    options = {
      number_of_calls: 1,
      calls_per_second: 1,
      max_concurrent: 1,
      destination: @test_run.target.address,
      source: TestRunner::BIND_IP,
      source_port: 8838,
      transport_mode: @test_run.profile.transport_type.to_s,
    }
    options[:scenario_variables] = write_csv_data @test_run.registration_scenario if @test_run.registration_scenario.csv_data.present?
    scenario = @test_run.registration_scenario.to_sippycup_scenario options
    cup = SippyCup::Runner.new scenario, full_sipp_output: false
    cup.run
  end

  def start_receiver_scenario
    return unless @test_run.receiver_scenario

    options = {
      source: TestRunner::BIND_IP,
      source_port: 8838,
      transport_mode: @test_run.profile.transport_type.to_s
    }

    options[:scenario_variables] = write_csv_data @test_run.receiver_scenario if @test_run.receiver_scenario.csv_data.present?

    scenario = @test_run.receiver_scenario.to_sippycup_scenario options
    @receiver_runner = SippyCup::Runner.new scenario, full_sipp_output: false, async: true
    @receiver_runner.run
  end

  def halt_receiver_scenario
    return unless @receiver_runner
    @receiver_runner.stop
    @receiver_runner.wait
  end

  def execute_runner
    runner_scenario = @test_run.scenario

    opts = {
      source: TestRunner::BIND_IP,
      destination: @test_run.target.address,
      number_of_calls: @test_run.profile.max_calls,
      calls_per_second: @test_run.profile.calls_per_second,
      max_concurrent: @test_run.profile.max_concurrent,
      to_user: @test_run.to_user,
      transport_mode: @test_run.profile.transport_type.to_s,
      vmstat_buffer: @vmstat_buffer,
      advertise_address: @test_run.advertise_address,
      from_user: @test_run.from_user,
      options: Psych.safe_load(@test_run.sipp_options),
    }

    opts[:scenario_variables] = write_csv_data @test_run.scenario if @test_run.scenario.csv_data.present?

    if @test_run.profile.calls_per_second_max
      opts[:calls_per_second_max] = @test_run.profile.calls_per_second_max
      opts[:calls_per_second_incr] = @test_run.profile.calls_per_second_incr
      opts[:calls_per_second_interval] = @test_run.profile.calls_per_second_interval
    end

    if has_stats_credentials?
      opts[:password] = @password
      opts[:username] = @test_run.target.ssh_username
    end

    @runner = Runner.new runner_name, runner_scenario, opts
    @runner.run
  end

  def path(suffix = '')
    File.join "/tmp", @jid, suffix
  end

  def write_csv_data(scenario)
    t = Tempfile.new 'csv'
    t.write scenario.csv_data
    t.rewind

    @csv_files << t
    t.path
  end

  def close_csv_files
    @csv_files.each do |f|
      f.close
      f.unlink
    end
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
    @test_run.target.ssh_username.present? && @password.present?
  end
end
