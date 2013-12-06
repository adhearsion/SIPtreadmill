require 'spec_helper'
require 'countdownlatch'

describe Runner do
  let(:rtcp_listener) { double :rtcp_listener }
  let(:sippy_cup_runner) { double :sippy_cup_runner }
  let(:e) { StandardError.new }
  let(:scenario) { double }

  subject(:runner) do
    Runner.new 'larry', scenario, my: :options
  end

  context '#run_and_catch_errors' do
    it 'should run the block passed to it' do
      mock_obj = double 'mock object'
      mock_obj.should_receive(:mock_method).once
      runner.run_and_catch_errors do
        mock_obj.mock_method
      end
    end

    it 'should report exceptions to Airbrake if mode airbrake is specified' do
      canary = double 'canary'
      latch = CountDownLatch.new 1
      canary.should_receive(:bang!).and_raise e
      Airbrake.should_receive(:notify).with e
      runner.run_and_catch_errors mode: :notify do
        canary.bang!
        latch.countdown!
      end
      latch.wait 2
      lambda { runner.check_ssh_errors }.should_not raise_error
    end

    it 'should not raise an SSH error if there were no problems with SSH' do
      mock_obj = double 'mock obj'
      latch = CountDownLatch.new 1
      mock_obj.should_receive(:mock_method).once
      runner.run_and_catch_errors mode: :error do
        mock_obj.mock_method
        latch.countdown!
      end
      latch.wait 2
      lambda { runner.check_ssh_errors }.should_not raise_error
    end

    it 'should raise an error if there were problems with SSH' do
      canary = double 'canary'
      latch = CountDownLatch.new 1
      canary.should_receive(:bang!).and_raise e
      runner.run_and_catch_errors mode: :error do
        canary.bang!
        latch.countdown!
      end
      latch.wait 2
      lambda { runner.check_ssh_errors }.should raise_error e
    end
  end

  describe "#run" do
    let(:rtcp_port){ 17000 }

    it "passes the same port to Listener and SippyCup" do
      Kernel.should_receive(:rand).and_return(rtcp_port)
      RTCPTools::Listener.should_receive(:new).with(rtcp_port+1).and_return rtcp_listener
      scenario.should_receive(:to_sippycup_scenario).and_return scenario
      rtcp_listener.stub(:run)
      rtcp_listener.stub(:stop)
      rtcp_listener.stub(:organize_data)
      SippyCup::Runner.should_receive(:new).with(scenario, full_sipp_output: false).and_return sippy_cup_runner
      sippy_cup_runner.should_receive(:run)
      subject.run
    end
  end
end
