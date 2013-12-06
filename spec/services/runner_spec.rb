require 'spec_helper'

describe Runner do
  let(:rtcp_listener) { double :rtcp_listener }
  let(:sippy_cup_runner) { double :sippy_cup_runner }
  let(:e) { StandardError.new }
  let(:scenario) { double }

  context '#run_rtcp_listener' do
    it 'should report exceptions thrown by the listener to Airbrake' do
      RTCPTools::Listener.should_receive(:new).and_return rtcp_listener
      runner = Runner.new 'larry', scenario, {my: :options}
      rtcp_listener.should_receive(:run).and_raise e
      Airbrake.should_receive(:notify).with e
      runner.run_rtcp_listener
    end
  end

  describe "#run" do
    let(:scenario) { double }

    subject do
      Runner.new 'larry', scenario,{my: :options} 
    end

    let(:rtcp_port){ 17000 }

    it "passes the same port to Listener and SippyCup" do
      Kernel.should_receive(:rand).and_return(rtcp_port)
      RTCPTools::Listener.should_receive(:new).with(rtcp_port+1).and_return rtcp_listener
      scenario.should_receive(:to_scenario_object).and_return scenario
      rtcp_listener.stub(:run)
      rtcp_listener.stub(:stop)
      rtcp_listener.stub(:organize_data)
      SippyCup::Runner.should_receive(:new).with(scenario).and_return sippy_cup_runner
      sippy_cup_runner.should_receive(:run)
      subject.run
    end
  end
end
