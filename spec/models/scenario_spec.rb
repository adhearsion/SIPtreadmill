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

  describe "exporting to disk" do
    include FakeFS::SpecHelpers

    context "with SippyCup steps specified" do
      subject { FactoryGirl.build :sippy_cup_scenario_with_complete_manifest }

      it "dumps the SippyCup scenario to disk in SIPp format" do
        subject.to_disk('/tmp', "scenario", source: 'foo', destination: 'bar')

        File.exists?("/tmp/scenario.xml").should be_true
        scenario_file = File.read("/tmp/scenario.xml")
        scenario_file.should =~ /INVITE/
        scenario_file.should =~ /My first scenario/
      end
    end

    context "with raw SIPp inputs" do
      subject { FactoryGirl.create(:sipp_scenario) }

      it "writes the scenario file to disk at a path with the specified prefix" do
        subject.to_disk('/tmp', "my_scenario")
        File.exists?("/tmp/my_scenario.xml").should be_true
        File.read("/tmp/my_scenario.xml").should == subject.sipp_xml
      end

      context "when interpolating the PCAP file path" do
        subject { FactoryGirl.create(:sipp_scenario, sipp_xml: "foobar - {{PCAP_AUDIO}}") }

        it "substitutes the PCAP file path" do
          subject.to_disk('/tmp', "my_scenario")
          File.read("/tmp/my_scenario.xml").should == "foobar - /tmp/my_scenario.pcap"
        end
      end

      context "with CSV data" do
        subject { FactoryGirl.create(:sipp_scenario, csv_data: "foo;123") }

        it "writes the CSV data to disk at a path with the specified prefix" do
          subject.to_disk('/tmp', "my_scenario")
          File.read("/tmp/my_scenario.csv").should include("foo;123")
        end
      end

      context "without CSV data" do
        it "does not create the CSV file" do
          subject.to_disk('/tmp', "my_scenario")
          File.exists?("/tmp/my_scenario.csv").should be_false
        end
      end

      context "with a pcap file" do
        before do
          # So that the fixture can be read from disk
          FakeFS.deactivate!
          subject
        end

        subject { FactoryGirl.create(:sipp_scenario_with_pcap) }

        it "writes the PCAP audio to disk" do
          body = File.read(File.join(Rails.root, 'spec', 'fixtures', 'dtmf_2833_1.pcap'), mode: 'rb')
          stub_request(:get, subject.pcap_audio.url).to_return(body: body, status: 200, headers: { 'Content-Length' => 14 })

          FakeFS.activate!
          subject.to_disk('/tmp', "my_scenario")
          File.exists?("/tmp/my_scenario.pcap").should be_true
          File.read("/tmp/my_scenario.pcap", mode: 'rb').should == body
        end
      end

       context "without a pcap file" do
        it "does not write PCAP to disk" do
          subject.to_disk('/tmp', "my_scenario")
          File.exists?("/tmp/my_scenario.pcap").should be_false
        end
      end
    end
  end
end
