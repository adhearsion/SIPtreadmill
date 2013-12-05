require 'spec_helper'

describe TestRunWorker do
  let(:test_run) {
    FactoryGirl.create(:test_run,
      name: "My Scenario",
      user: FactoryGirl.build(:user),
      scenario: FactoryGirl.build(:scenario, id: 1),
      profile: FactoryGirl.build(:profile, id: 1),
      target: FactoryGirl.build(:target, id: 1),
      state: 'queued'
    )
  }

  let(:test_run_id) { test_run.id }

  let(:test_runner) { double }

  before do
    subject.stub jid: 'abc123'
  end

  describe "#perform" do
    context "normal operation" do
      before do
        TestRunner.should_receive(:new).with(test_run, 'abc123', nil).and_return(test_runner)
        subject.should_receive(:check_for_stop_signal).and_return false
        subject.should_receive(:stop_signal_listener)
      end

      it "should set the status to 'running'" do
        test_runner.should_receive(:run).and_return do
          test_run.reload
          test_run.state.should == 'running'
        end
        test_runner.should_receive(:stopped).and_return false

        subject.perform test_run_id
      end

      it "should set the status to 'complete' when done" do
        test_runner.should_receive(:run)
        test_runner.should_receive(:stopped).and_return false

        subject.perform test_run_id

        test_run.reload
        test_run.state.should == 'complete'
      end

      it "should set the status to 'pending' if the job was stopped" do
        test_runner.should_receive(:run)
        test_runner.should_receive(:stopped).and_return true

        subject.perform test_run_id

        test_run.reload
        test_run.state.should == 'pending'
      end

      it "should set the status to 'complete_with_errors' in case of an exception" do
        test_runner.should_receive(:run).and_raise(StandardError, "something horrible went wrong")

        expect { subject.perform test_run_id }.to raise_error StandardError, "something horrible went wrong"

        test_run.reload
        test_run.state.should == 'complete_with_errors'
      end

      it "should set the error_name and error_message in case of an exception" do
        error_message = "something horrible went wrong"
        test_runner.should_receive(:run).and_raise(StandardError, error_message)

        expect { subject.perform test_run_id }.to raise_error StandardError, error_message

        test_run.reload
        test_run.error_name.should == 'StandardError'
        test_run.error_message.should == error_message
      end
    end

    context "stop signal" do
      it "should not even start if there is a stop signal" do
        subject.should_receive(:check_for_stop_signal).and_return true
        TestRun.should_receive(:find).never
        TestRunner.should_receive(:new).never
        subject.perform test_run_id
      end
    end
  end

  describe '#check_for_stop_signal' do
    it "returns false if there is any exception" do
      mock_redis = double('redis')
      Sidekiq.should_receive(:redis).and_raise
      subject.check_for_stop_signal.should == false
    end
  end
end
