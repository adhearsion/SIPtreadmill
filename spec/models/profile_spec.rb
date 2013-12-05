require 'spec_helper'

describe Profile do
  context "validations" do
    it "should not accept a profile without a name" do
      FactoryGirl.build(:profile, name: nil).should_not be_valid
    end

    it "should not accept a profile without a calls_per_second" do
      FactoryGirl.build(:profile, calls_per_second: nil).should_not be_valid
    end

    it "should not accept a profile without a max_calls" do
      FactoryGirl.build(:profile, max_calls: nil).should_not be_valid
    end

    it "should not accept a profile without a max_concurrent" do
      FactoryGirl.build(:profile, max_concurrent: nil).should_not be_valid
    end

    it "should not accept the same name twice" do
      FactoryGirl.create(:profile)
      FactoryGirl.build(:profile).should_not be_valid
    end
  end
end