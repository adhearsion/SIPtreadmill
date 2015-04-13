require 'spec_helper'

class HomeClass
  include HomeHelper
end
describe HomeHelper do
  context "Included in a class" do
    subject { HomeClass.new }

    describe "#get_completed_test_runs" do
      let(:time1) { Time.new(2012,12,21,5,12,21) }
      let(:time2) { Time.new(2012,12,21,1,12,21) }
      let(:time3) { Time.new(2012,12,22,1,12,22) }
      let(:tr1) { FactoryGirl.create :test_run, completed_at: time1, state: "complete" }
      let(:tr2) { FactoryGirl.create :test_run, completed_at: time2, state: "complete" }
      let(:tr3) { FactoryGirl.create :test_run, completed_at: time3, state: "complete_with_errors" }
      before do
        @tr1 = FactoryGirl.create :test_run, completed_at: time1, state: "complete"
        @tr2 = FactoryGirl.create :test_run, completed_at: time2, state: "complete"
        @tr3 = FactoryGirl.create :test_run, completed_at: time3, state: "complete"
        @ability = Object.new
        @ability.extend(CanCan::Ability)
        subject.stub(:current_ability) { @ability }
      end
      it "should return the proper data structure" do
        @ability.can :read, TestRun
        subject.get_completed_test_runs.should == [{key: "Completed Successfully",
                                                    values: [["2012-12-21", 2], ["2012-12-22", 1]] }].to_json
      end
    end
  end
end