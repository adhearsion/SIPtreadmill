require 'spec_helper'

describe TestRunner do
  let(:scenario) { FactoryGirl.build(:sipp_scenario) }
  let(:test_run) { FactoryGirl.create(:test_run, scenario: scenario) }

  let(:jid) { 'abc123' }
  subject { TestRunner.new test_run, jid }

  let(:options) do
    {
      source: TestRunner::BIND_IP,
      number_of_calls: test_run.profile.max_calls,
      calls_per_second: test_run.profile.calls_per_second,
      max_concurrent: test_run.profile.max_concurrent,
      transport_mode: test_run.profile.transport_type.to_s,
      vmstat_buffer: an_instance_of(Array),
      destination: test_run.target.address
    }
  end

  let(:mock_runner) { double run: {} }

  let(:runner_options) { { full_sipp_output: false, async: true } }

  it "instantiates the runner with the correct parameters" do
    Runner.should_receive(:new).with("myfirsttest_run", scenario, options).and_return(mock_runner)
    mock_runner.should_receive(:run)
    subject.run
  end

  context "when the test run has a receiver scenario" do
    let(:receiver_scenario) { FactoryGirl.build(:sipp_scenario, receiver: true) }
    let(:test_run) { FactoryGirl.create(:test_run, scenario: scenario, receiver_scenario: receiver_scenario, jid: jid) }
    let(:receiver_options) do
      {
        source: TestRunner::BIND_IP,
        source_port: 8838,
        transport_mode: test_run.profile.transport_type.to_s
      }
    end

    let(:receiver_sippy) { receiver_scenario.to_sippycup_scenario receiver_options }
    let(:receiver_runner) { double run: {} }

    it "starts the receiver scenario before the main scenario" do
      receiver_scenario.should_receive(:to_sippycup_scenario).twice.with(receiver_options).ordered.and_return(receiver_sippy)
      SippyCup::Runner.should_receive(:new).with(receiver_sippy, runner_options).ordered.and_return(receiver_runner)
      receiver_runner.should_receive :run
      receiver_runner.should_receive :wait

      Runner.should_receive(:new).with("myfirsttest_run", scenario, options).ordered.and_return(mock_runner)
      mock_runner.should_receive(:run).ordered
      receiver_runner.should_receive :stop
      subject.run
    end

    it "should terminate the receiver scenario if any problems ocurr" do
      receiver_scenario.should_receive(:to_sippycup_scenario).twice.with(receiver_options).ordered.and_return(receiver_sippy)
      SippyCup::Runner.should_receive(:new).with(receiver_sippy, runner_options).ordered.and_return(receiver_runner)
      receiver_runner.should_receive :run
      receiver_runner.should_receive :wait 

      Runner.should_receive(:new).and_raise StandardError
      receiver_runner.should_receive :stop
      expect { subject.run }.to raise_error StandardError
    end

    context "with CSV data" do
      let(:receiver_scenario) { FactoryGirl.build(:sipp_scenario, receiver: true, csv_data: 'abc;123') }

      before do
        receiver_options[:scenario_variables] = "/tmp/receiver.csv"
      end

      it "writes the receiver scenario csv data and passes it to SippyCup" do
        subject.should_receive(:write_csv_data).with(receiver_scenario).ordered.and_return "/tmp/receiver.csv"
        receiver_scenario.should_receive(:to_sippycup_scenario).twice.with(receiver_options).and_return(receiver_sippy)
        SippyCup::Runner.should_receive(:new).with(receiver_sippy, runner_options).ordered.and_return(receiver_runner)
        receiver_runner.should_receive :run
        receiver_runner.should_receive :wait

        Runner.should_receive(:new).with("myfirsttest_run", scenario, options).ordered.and_return(mock_runner)
        mock_runner.should_receive(:run).ordered
        receiver_runner.should_receive :stop
        subject.run 
      end
    end

    context "and a registration scenario" do
      let(:registration_scenario) { FactoryGirl.build(:sipp_scenario, receiver: true) }
      let(:receiver_scenario) { FactoryGirl.build(:sipp_scenario, receiver: true, registration_scenario: registration_scenario) }
      let(:runner_options) { { full_sipp_output: false } }

      it "writes the receiver scenario to disk and starts it before starting the main scenario" do
        reg_options = {
          number_of_calls: 1,
          calls_per_second: 1,
          max_concurrent: 1,
          destination: test_run.target.address,
          source: TestRunner::BIND_IP,
          source_port: 8837,
          transport_mode: 'u1',
        }
        reg_sippy = registration_scenario.to_sippycup_scenario reg_options
        mock_reg_runner = double 'SippyCup::Runner'
        registration_scenario.should_receive(:to_sippycup_scenario).with(reg_options).ordered.and_return reg_sippy
        SippyCup::Runner.should_receive(:new).with(reg_sippy, runner_options).ordered.and_return(mock_reg_runner)
        mock_reg_runner.should_receive(:run).ordered

        receiver_scenario.should_receive(:to_sippycup_scenario).twice.with(receiver_options).and_return(receiver_sippy)
        SippyCup::Runner.should_receive(:new).with(receiver_sippy, runner_options.merge(async: true)).ordered.and_return(receiver_runner)
        receiver_runner.should_receive :run
        receiver_runner.should_receive :wait

        Runner.should_receive(:new).with("myfirsttest_run", scenario, options).ordered.and_return(mock_runner)
        mock_runner.should_receive(:run).ordered

        receiver_runner.should_receive :stop
        subject.run
      end

      context "with CSV data" do
        let(:registration_scenario) { FactoryGirl.build(:sipp_scenario, receiver: true, csv_data: 'abc;123') }
        let(:runner_options) { { full_sipp_output: false } }

        it "passes the :scenario_variables option to the registration runner" do
          reg_options = {
            number_of_calls: 1,
            calls_per_second: 1,
            max_concurrent: 1,
            destination: test_run.target.address,
            source: TestRunner::BIND_IP,
            source_port: 8837,
            transport_mode: 'u1',
            scenario_variables: '/tmp/reg.csv'
          }
          reg_sippy = registration_scenario.to_sippycup_scenario reg_options
          mock_reg_runner = double 'SippyCup::Runner'
          subject.should_receive(:write_csv_data).with(registration_scenario).and_return '/tmp/reg.csv'
          registration_scenario.should_receive(:to_sippycup_scenario).with(reg_options).ordered.and_return reg_sippy
          SippyCup::Runner.should_receive(:new).with(reg_sippy, runner_options).ordered.and_return(mock_reg_runner)
          mock_reg_runner.should_receive(:run).ordered

          receiver_scenario.should_receive(:to_sippycup_scenario).twice.with(receiver_options).and_return(receiver_sippy)
          SippyCup::Runner.should_receive(:new).with(receiver_sippy, runner_options.merge(async: true)).ordered.and_return(receiver_runner)
          receiver_runner.should_receive :run
          receiver_runner.should_receive :wait

          Runner.should_receive(:new).with("myfirsttest_run", scenario, options).ordered.and_return(mock_runner)
          mock_runner.should_receive(:run).ordered

          receiver_runner.should_receive :stop
          subject.run
        end
      end
    end
  end

  context "with CSV" do
    let(:scenario) { FactoryGirl.build(:sipp_scenario, id: 1, csv_data: "foo;123") }

    before do
      options[:scenario_variables] = '/tmp/data.csv'
    end

    it "passes the :scenario_variables option to the runner" do
      subject.should_receive(:write_csv_data).with(scenario).and_return '/tmp/data.csv'
      Runner.should_receive(:new).with("myfirsttest_run", scenario, options).and_return(mock_runner)
      mock_runner.should_receive(:run)
      subject.run
    end
  end
end
