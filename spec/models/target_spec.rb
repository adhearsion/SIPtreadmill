require 'spec_helper'

describe Target do
  context "validations" do
    it "should not accept a target without a name" do
      FactoryGirl.build(:target, name: nil).should_not be_valid
    end

    it "should not accept a target without an address" do
      FactoryGirl.build(:target, address: nil).should_not be_valid
    end

    it "should not accept the same name twice" do
      FactoryGirl.create(:target)
      FactoryGirl.build(:target).should_not be_valid
    end
  end
end