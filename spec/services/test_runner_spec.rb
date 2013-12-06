require 'spec_helper'

describe TestRunner do
  let(:scenario) { FactoryGirl.build(:sipp_scenario) }
  let(:test_run) { FactoryGirl.create(:test_run, scenario: scenario) }

  let(:jid) { 'abc123' }
  subject { TestRunner.new test_run, jid }

  before { scenario.stub(:to_disk) }

  let(:runner_scenario) do
    {
      scenario: "/tmp/abc123/scenario",
      source: TestRunner::BIND_IP
    }
  end

  let(:runner_profile) do
    {
      number_of_calls: test_run.profile.max_calls,
      calls_per_second: test_run.profile.calls_per_second,
      max_concurrent: test_run.profile.max_concurrent,
      source_port: 8836,
      transport_mode: test_run.profile.transport_type.to_s,
      vmstat_buffer: an_instance_of(Array)
    }
  end

  let(:runner_target) do
    {
      destination: test_run.target.address
    }
  end

  let(:mock_runner) { double run: {} }

  it "writes the scenario to disk and instantiates the runner with the correct parameters" do
    Kernel.should_receive(:rand).twice.with(5000...10000).and_return 8837, 8836
    scenario.should_receive(:to_disk).once.with('/tmp/abc123/', 'scenario',
      source: "#{TestRunner::BIND_IP}:#{TestRunner::SIPPYCUP_TARGET_PORT}",
      destination: test_run.target.address)
    Runner.should_receive(:new).with("myfirsttest_run", runner_scenario, runner_profile, runner_target).and_return(mock_runner)
    mock_runner.should_receive(:run)
    subject.run
  end

  context "when the test run has a receiver scenario" do
    let(:receiver_scenario) { FactoryGirl.build(:sipp_scenario, receiver: true) }
    let(:test_run) { FactoryGirl.create(:test_run, scenario: scenario, receiver_scenario: receiver_scenario, jid: jid) }

    before { receiver_scenario.stub(:to_disk) }

    it "writes the receiver scenario to disk and starts it before starting the main scenario" do
      Kernel.should_receive(:rand).twice.with(5000...10000).and_return 8837, 8836
      receiver_scenario.should_receive(:to_disk).once.with('/tmp/abc123/', 'receiver_scenario').ordered

      pid = '1234'
      Process.should_receive(:spawn).with("sipp -sf /tmp/abc123/receiver_scenario.xml -i #{TestRunner::BIND_IP} -p 8837 -t u1", out: '/dev/null', err: '/dev/null').ordered.and_return pid

      scenario.should_receive(:to_disk).once.with('/tmp/abc123/', 'scenario',
        source: "#{TestRunner::BIND_IP}:#{TestRunner::SIPPYCUP_TARGET_PORT}",
        destination: test_run.target.address).ordered
      Runner.should_receive(:new).with("myfirsttest_run", runner_scenario, runner_profile, runner_target).ordered.and_return(mock_runner)
      mock_runner.should_receive(:run).ordered
      Process.should_receive(:kill).with("KILL", pid).ordered
      subject.run
    end

    it "should not fail if the receiver scenario was stopped before attempting to halt it" do
      pid = '1234'
      Kernel.should_receive(:rand).twice.with(5000...10000).and_return 8837, 8836
      Process.should_receive(:spawn).with("sipp -sf /tmp/abc123/receiver_scenario.xml -i #{TestRunner::BIND_IP} -p 8837 -t u1", out: '/dev/null', err: '/dev/null').ordered.and_return pid
      Runner.should_receive(:new).with("myfirsttest_run", runner_scenario, runner_profile, runner_target).ordered.and_return(mock_runner)
      mock_runner.should_receive(:run).ordered
      Process.should_receive(:kill).with("KILL", pid).ordered.and_raise(Errno::ESRCH)
      subject.run
    end

    it "should terminate the receiver scenario if any problems ocurr" do
      Kernel.should_receive(:rand).twice.with(5000...10000).and_return 8837, 8836
      pid = '1234'
      Process.should_receive(:spawn).with("sipp -sf /tmp/abc123/receiver_scenario.xml -i #{TestRunner::BIND_IP} -p 8837 -t u1", out: '/dev/null', err: '/dev/null').ordered.and_return pid

      scenario.should_receive(:to_disk).and_raise StandardError

      Process.should_receive(:kill).with("KILL", pid).ordered
      expect { subject.run }.to raise_error StandardError
    end

    context "with CSV data" do
      let(:receiver_scenario) { FactoryGirl.build(:sipp_scenario, receiver: true, csv_data: 'abc;123') }

      it "passes -inf to SIPp" do
        pid = '1234'
        Kernel.should_receive(:rand).twice.with(5000...10000).and_return 8837, 8836
        Process.should_receive(:spawn).with("sipp -sf /tmp/abc123/receiver_scenario.xml -i #{TestRunner::BIND_IP} -p 8837 -inf /tmp/abc123/receiver_scenario.csv -t u1", out: '/dev/null', err: '/dev/null').ordered.and_return pid
        Runner.should_receive(:new).with("myfirsttest_run", runner_scenario, runner_profile, runner_target).ordered.and_return(mock_runner)
        mock_runner.should_receive(:run).ordered
        Process.should_receive(:kill).with("KILL", pid).ordered.and_raise(Errno::ESRCH)
        subject.run
      end
    end

    context "and a registration scenario" do
      let(:registration_scenario) { FactoryGirl.build(:sipp_scenario, receiver: true) }
      let(:receiver_scenario) { FactoryGirl.build(:sipp_scenario, receiver: true, registration_scenario: registration_scenario) }

      before { registration_scenario.stub(:to_disk) }

      it "writes the receiver scenario to disk and starts it before starting the main scenario" do
        Kernel.should_receive(:rand).twice.with(5000...10000).and_return 8837, 8836
        registration_scenario.should_receive(:to_disk).once.with('/tmp/abc123/', 'registration_scenario').ordered
        reg_options = {
          scenario: "/tmp/abc123/registration_scenario",
          number_of_calls: 1,
          calls_per_second: 1,
          max_concurrent: 1,
          destination: test_run.target.address,
          source: TestRunner::BIND_IP,
          source_port: 8837,
          transport_mode: 'u1',
          full_sipp_output: false
        }
        mock_reg_runner = double 'SippyCup::Runner'
        SippyCup::Runner.should_receive(:new).with(reg_options).ordered.and_return(mock_reg_runner)
        mock_reg_runner.should_receive(:run).ordered

        receiver_scenario.should_receive(:to_disk).once.with('/tmp/abc123/', 'receiver_scenario').ordered

        pid = '1234'
        Process.should_receive(:spawn).with("sipp -sf /tmp/abc123/receiver_scenario.xml -i #{TestRunner::BIND_IP} -p 8837 -t u1", out: '/dev/null', err: '/dev/null').ordered.and_return pid

        scenario.should_receive(:to_disk).once.with('/tmp/abc123/', 'scenario',
          source: "#{TestRunner::BIND_IP}:#{TestRunner::SIPPYCUP_TARGET_PORT}",
          destination: test_run.target.address).ordered
        Runner.should_receive(:new).with("myfirsttest_run", runner_scenario, runner_profile, runner_target).ordered.and_return(mock_runner)
        mock_runner.should_receive(:run).ordered
        Process.should_receive(:kill).with("KILL", pid).ordered
        subject.run
      end

      context "with CSV data" do
        let(:registration_scenario) { FactoryGirl.build(:sipp_scenario, receiver: true, csv_data: 'abc;123') }

        it "passes the :scenario_variables option to the registration runner" do
          mock_reg_runner = double 'SippyCup::Runner'
          Kernel.should_receive(:rand).twice.with(5000...10000).and_return 8837, 8836
          SippyCup::Runner.should_receive(:new).with(hash_including(scenario_variables: "/tmp/abc123/registration_scenario.csv")).ordered.and_return(mock_reg_runner)
          mock_reg_runner.should_receive(:run).ordered

          pid = '1234'
          Process.should_receive(:spawn).with("sipp -sf /tmp/abc123/receiver_scenario.xml -i #{TestRunner::BIND_IP} -p 8837 -t u1", out: '/dev/null', err: '/dev/null').ordered.and_return pid

          Runner.should_receive(:new).with("myfirsttest_run", runner_scenario, runner_profile, runner_target).ordered.and_return(mock_runner)
          mock_runner.should_receive(:run).ordered
          Process.should_receive(:kill).with("KILL", pid).ordered
          subject.run
        end
      end
    end
  end

  context "with CSV" do
    let(:scenario) { FactoryGirl.build(:sipp_scenario, id: 1, csv_data: "foo;123") }

    let(:runner_scenario) do
      {
        scenario: "/tmp/abc123/scenario",
        scenario_variables: "/tmp/abc123/scenario.csv",
        source: TestRunner::BIND_IP
      }
    end

    it "passes the :scenario_variables option to the runner" do
      Kernel.should_receive(:rand).twice.with(5000...10000).and_return 8837, 8836
      Runner.should_receive(:new).with("myfirsttest_run", runner_scenario, runner_profile, runner_target).and_return(mock_runner)
      mock_runner.should_receive(:run)
      subject.run
    end
  end
end
