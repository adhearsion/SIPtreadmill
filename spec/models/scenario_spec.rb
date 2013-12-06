require 'spec_helper'

describe Scenario do
  context "validations" do
    it "should not accept a scenario without a name" do
      FactoryGirl.build(:scenario, name: nil).should_not be_valid
    end

    it "should not accept the same name twice" do
      FactoryGirl.create(:scenario)
      FactoryGirl.build(:scenario).should_not be_valid
    end

    it "should not accept an invalid SippyCup scenario" do
      scenario = FactoryGirl.build :sippy_cup_scenario, sippy_cup_scenario: "send_digits 'abc'"
      scenario.should_not be_valid
      scenario.errors.messages[:sippy_cup_scenario].should == ["send_digits 'abc': Invalid DTMF digit requested: a (Step 1)"]
    end

    it "should accept a valid SippyCup scenario" do
      scenario = FactoryGirl.build :sippy_cup_scenario
      scenario.should be_valid
    end
  end

  context '#to_scenario_object' do
    context 'XML Scenario' do
      let(:scenario) { FactoryGirl.build :sipp_scenario }
      let(:options) do
        {
          source: "127.0.0.1",
          destination: "127.0.0.1"  
        }
      end
      it 'should return a SippyCup::XMLScenario object' do
        object = scenario.to_scenario_object options
        object.should be_a(SippyCup::XMLScenario)
      end
    end

    context 'SippyCup Scenario' do
      let(:scenario) { FactoryGirl.build :sippy_cup_scenario }
      let(:options) do
        {
          source: "127.0.0.1",
          destination: "127.0.0.1"  
        }
      end
      it 'should return a SippyCup::Scenario object' do
        object = scenario.to_scenario_object options
        object.should be_a(SippyCup::Scenario)
        object.to_xml.should match(%r{INVITE})
      end
    end
  end
end
