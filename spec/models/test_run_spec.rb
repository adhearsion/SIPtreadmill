require 'spec_helper'

describe TestRun do
  let(:test_time) { Time.local(2008, 9, 1, 12, 0, 0) }

  subject { FactoryGirl.create :test_run }

  context "validations" do
    let(:sender_scenario) { FactoryGirl.build(:scenario, receiver: false) }
    let(:receiver_scenario) { FactoryGirl.build(:scenario, receiver: true) }
    let(:registration_scenario) { FactoryGirl.build(:scenario, receiver: true) }

    it "should not accept a test run without any scenarios" do
      FactoryGirl.build(:test_run, scenario: nil, receiver_scenario: nil).should_not be_valid
    end

    it "should accept a test run with a sender scenario" do
      FactoryGirl.build(:test_run, scenario: sender_scenario, receiver_scenario: nil).should be_valid
    end

    it "should accept a test run with a receiver scenario" do
      FactoryGirl.build(:test_run, scenario: nil, receiver_scenario: receiver_scenario).should be_valid
    end

    it "should accept a test run with a receiver & registration scenario" do
      FactoryGirl.build(:test_run, scenario: nil, receiver_scenario: receiver_scenario).should be_valid
    end

    it "should accept a test run with all scenarios" do
      FactoryGirl.build(:test_run, scenario: sender_scenario, receiver_scenario: receiver_scenario).should be_valid
    end

    it "should only accept a test run with a sender scenario that has receiver set to false" do
      FactoryGirl.build(:test_run, scenario: receiver_scenario, receiver_scenario: nil).should_not be_valid
    end

     it "should only accept a test run with a receiver scenario that has receiver set to true" do
      FactoryGirl.build(:test_run, scenario: nil, receiver_scenario: sender_scenario).should_not be_valid
    end

    it "should not accept a test run without a name" do
      FactoryGirl.build(:test_run, name: nil).should_not be_valid
    end
  end

  context "#enqueue" do
    context "with a pending job" do
      let(:state) { 'pending' }
      let(:jid) { '123456789' }

      it 'enqueues and saves the JID' do
        Timecop.freeze(test_time) do
          TestRunWorker.should_receive(:perform_async).with(subject.id, nil).and_return(jid)
          subject.enqueue.should == true

          subject.reload

          subject.state.should == 'queued'
          subject.jid.should == jid
          subject.enqueued_at.should == test_time
        end
      end

      it 'raises when unable to enqueue the job' do
        Timecop.freeze(test_time) do
          TestRunWorker.should_receive(:perform_async).with(subject.id, nil).and_return(nil)
          expect { subject.enqueue }.to raise_error
        end
      end

      it 'enqueues and saves the JID when there is a password' do
        Timecop.freeze(test_time) do
          TestRunWorker.should_receive(:perform_async).with(subject.id, 'SEEKRIT').and_return(jid)
          subject.enqueue('SEEKRIT').should == true

          subject.reload

          subject.state.should == 'queued'
          subject.jid.should == jid
          subject.enqueued_at.should == test_time
        end
      end
    end

    context "with a job not pending" do
      it 'does not enqueue the job twice' do
        subject.state = 'queued'
        TestRunWorker.should_receive(:perform_async).never
        subject.enqueue.should == false
      end
    end
  end

  context "#start" do
    it "should set the started_at time" do
      Timecop.freeze(test_time) do
        subject.state = 'queued'
        subject.start

        subject.reload

        subject.started_at.should == test_time
        subject.state.should == 'running'
      end
    end

    it "can transition from pending to running if worker beats the UI" do
      Timecop.freeze(test_time) do
        subject.state = 'pending'
        subject.start!

        subject.reload

        subject.started_at.should == test_time
        subject.state.should == 'running'
      end
    end
  end

  context "#complete" do
    it "sets the started_at value" do
      Timecop.freeze(test_time) do
        subject.state = 'running'
        subject.complete

        subject.reload

        subject.completed_at.should == test_time
      end
    end
  end

  context "#cancel" do
    let(:jid) { '123456789'}
    subject { FactoryGirl.build :test_run, jid: jid }

    before do
      subject.state = 'queued'
    end

    it 'deletes the job from the queue if found and returns true, setting status back to pending' do
      job = double(jid: jid)
      queue = double('queue')
      Sidekiq::Queue.should_receive(:new).and_return(queue)
      queue.should_receive(:each).and_yield(job)
      job.should_receive(:delete)
      subject.cancel.should == true

      subject.reload

      subject.state.should == 'pending'
    end

    it 'does nothing if not found' do
      job = double(jid: 'abc123')
      queue = double('queue')
      Sidekiq::Queue.should_receive(:new).and_return(queue)
      queue.should_receive(:each).and_yield(job)
      job.should_receive(:delete).never
      subject.cancel

      subject.reload

      subject.state.should == 'pending'
    end
  end

  context "#stop" do
    subject { FactoryGirl.build :test_run, jid: jid }

    before do
      subject.state = 'running'
    end

    context "with a jid" do
      let(:jid) { '123456789'}
      it "puts the jid on the stop namespace" do
        mock_redis = double("mock_redis")
        mock_redis.should_receive(:sadd).with(TestRun::STOP_JOBS_NAMESPACE,  jid)
        Sidekiq.should_receive(:redis).and_yield(mock_redis)
        subject.stop
      end
    end

    context "without a jid" do
      let(:jid) { nil }
      it "does nothing" do
        Sidekiq.should_receive(:redis).never
        subject.stop
      end
    end
  end

  describe "#complete_with_errors" do
    it "sets the state to :complete_with_errors" do
      subject.complete_with_errors
      subject.reload
      subject.state.should == 'complete_with_errors'
    end
  end

  context "#duplicate" do
    it "should duplicate the test run" do
      test_run = FactoryGirl.create :test_run, user: FactoryGirl.build(:user), scenario: FactoryGirl.build(:scenario),
                      profile: FactoryGirl.build(:profile), target: FactoryGirl.build(:target), name: "TestRun"
      new_tr = test_run.duplicate
      new_tr.user.should == test_run.user
      new_tr.scenario.should == test_run.scenario
      new_tr.profile.should == test_run.profile
      new_tr.target.should == test_run.target
      new_tr.name.should == "TestRun Retry 1"
    end

    it "should increment the number correctly" do
      test_run = FactoryGirl.create :test_run, user: FactoryGirl.build(:user), scenario: FactoryGirl.build(:scenario),
                      profile: FactoryGirl.build(:profile), target: FactoryGirl.build(:target), name: "TestRun Retry 1"
      new_tr = test_run.duplicate
      new_tr.user.should == test_run.user
      new_tr.scenario.should == test_run.scenario
      new_tr.profile.should == test_run.profile
      new_tr.target.should == test_run.target
      new_tr.name.should == "TestRun Retry 2"
    end
  end

  context "graph data" do
    describe "#total_calls_json" do
      let(:test_run) { FactoryGirl.build :test_run, id: 1, state: 'complete' }
      let(:sipp_datum_one) { FactoryGirl.build :sipp_datum, id: 1, successful_calls: 1, failed_calls: 0, concurrent_calls: 1, test_run: test_run }
      let(:sipp_datum_two) { FactoryGirl.build :sipp_datum, id: 2, successful_calls: 1, failed_calls: 1, concurrent_calls: 1, test_run: test_run }
      let(:sipp_data) { double :sipp_data, all: [sipp_datum_one, sipp_datum_two] }

      it "should return the proper data structure" do
        test_run.stub(:sipp_data).and_return sipp_data
        test_run.total_calls_json.should == [{ key: "Successful", values: [[946732563000, 1], [946732563000, 1]] },
                                             { key: "Failed", values: [[946732563000, 0], [946732563000, 1]] },
                                             { key: "Started", values: [[946732563000, 1],[946732563000, 1]] }].to_json
      end
    end

    describe "#jitter_json" do
      let(:test_run) { FactoryGirl.build :test_run, id: 1, state: 'complete' }
      let(:rtcp_datum_one) { FactoryGirl.build :rtcp_datum, id: 1, avg_jitter: 1, max_jitter: 2, test_run: test_run }
      let(:rtcp_datum_two) { FactoryGirl.build :rtcp_datum, id: 1, avg_jitter: 2, max_jitter: 4, test_run: test_run }
      let(:rtcp_data) { double :rtcp_data, all: [rtcp_datum_one, rtcp_datum_two] }

      it "should return the proper data structure" do
        test_run.stub(:rtcp_data).and_return rtcp_data
        test_run.jitter_json.should == [{key: "Average Jitter", values: [[946731253000, 1.0],[946731253000, 2.0]]},
                                        {key: "Max Jitter", values: [[946731253000,2.0],[946731253000,4.0]]}].to_json
      end
    end

    describe "#call_rate_json" do
      let(:test_run) { FactoryGirl.build :test_run, id: 1, state: 'complete' }
      let(:sipp_datum_one) { FactoryGirl.build :sipp_datum, id: 1, cps: 1.5, concurrent_calls: 3, test_run: test_run }
      let(:sipp_datum_two) { FactoryGirl.build :sipp_datum, id: 2, cps: 1.0, concurrent_calls: 5, test_run: test_run }
      let(:sipp_data) { double :sipp_data, all: [sipp_datum_one, sipp_datum_two] }

      it "should return the proper data structure" do
        test_run.stub(:sipp_data).and_return sipp_data
        test_run.call_rate_json.should == [{key: "Calls Per Second", values: [[946732563000, 1.5],[946732563000, 1.0]]},
                                           {key: "Concurrent Calls", values: [[946732563000, 3], [946732563000, 5]]}].to_json
      end
    end

    describe "#packet_loss_json" do
      let(:test_run) { FactoryGirl.build :test_run, id: 1, state: 'complete' }
      let(:rtcp_datum_one) { FactoryGirl.build :rtcp_datum, id: 1, avg_packet_loss: 1.0, max_packet_loss: 2.0, test_run: test_run }
      let(:rtcp_datum_two) { FactoryGirl.build :rtcp_datum, id: 1, avg_packet_loss: 2.0, max_packet_loss: 4.0, test_run: test_run }
      let(:rtcp_data) { double :rtcp_data, all: [rtcp_datum_one, rtcp_datum_two] }

      it "should return the proper data structure" do
        test_run.stub(:rtcp_data).and_return rtcp_data
        test_run.packet_loss_json.should == [{key: "Average Packet Loss", values: [[946731253000, 1.0],[946731253000, 2.0]] },
                                             {key: "Max Packet Loss", values: [[946731253000,2.0],[946731253000,4.0]] }].to_json
      end
    end

    describe "#target_resources_json" do
      let(:test_run) { FactoryGirl.build :test_run, id: 1, state: 'complete' }
      let(:system_load_datum_one) { FactoryGirl.build :system_load_datum, id: 1, cpu: 1.0, memory: 2.0, test_run: test_run }
      let(:system_load_datum_two) { FactoryGirl.build :system_load_datum, id: 1, cpu: 2.0, memory: 4.0, test_run: test_run }
      let(:system_load_data) { double :system_load_data, all: [system_load_datum_one, system_load_datum_two] }

      it "should return the proper data structure" do
        test_run.stub(:system_load_data).and_return system_load_data
        test_run.target_resources_json.should == [{key: "CPU", values: [[1376399763000, 1.0],[1376399763000, 2.0]] },
                                             {key: "Memory", values: [[1376399763000,2.0],[1376399763000,4.0]] }].to_json
      end
    end
  end
end
