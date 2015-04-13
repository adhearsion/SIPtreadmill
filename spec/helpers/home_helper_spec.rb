require 'spec_helper'

class HomeClass
  include HomeHelper
end
describe HomeHelper do
  context "Included in a class" do
    subject { HomeClass.new }

    describe "#get_completed_test_runs" do
      before do
        ability = Object.new
        ability.extend(CanCan::Ability)
        ability.can :read, TestRun
        subject.stub(:current_ability) { ability }

        [
          Time.new(2012,12,21,5,12,21),
          Time.new(2012,12,21,1,12,21),
          Time.new(2012,12,22,1,12,22),
        ].each { |time| FactoryGirl.create :test_run, completed_at: time, state: "complete" }
      end

      it "should return the proper data structure" do
        subject.get_completed_test_runs.should == [
          {
            key: "Completed Successfully",
            values: [
              ["2012-12-21", 2],
              ["2012-12-22", 1],
            ]
          }
        ].to_json
      end
    end
  end
end
