class TestRunWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(test_run_id, password = nil)
    test_run = nil
    return if check_for_stop_signal

    test_run = TestRun.find test_run_id
    test_run.start!

    @test_runner = TestRunner.new test_run, jid, password

    @listener_running = true
    stop_signal_listener

    @test_runner.run

    if @test_runner.stopped
      test_run.stop!
    else
      test_run.complete!
    end
  rescue => e
    test_run.error_name = e.class.to_s
    test_run.error_message = e.message
    test_run.complete_with_errors if test_run
    raise
  ensure
    @listener_running = false
  end

  def check_for_stop_signal
    Sidekiq.redis do |r|
      result = r.srem(TestRun::STOP_JOBS_NAMESPACE, jid)
      return result
    end
  rescue
    false
  end

  def stop_signal_listener
    Thread.new do
      while @listener_running do
        sleep(1)
        if check_for_stop_signal
          @test_runner.stop
          @listener_running = false
        end
      end
    end
  end
end
