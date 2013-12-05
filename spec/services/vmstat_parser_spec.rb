require 'spec_helper'

describe VMStatParser do
  let(:test_run) { FactoryGirl.create :test_run }
  let(:vmstat_buffer) { File.read(File.join(Rails.root,'spec/fixtures/vmstat_fixture.log')).split("\n") }

  subject { VMStatParser.new vmstat_buffer, test_run }

  it "should parse the data and save it to the test run" do
    subject.parse
    first_data = test_run.system_load_data.first
    first_data.cpu.should == 46.0
    first_data.memory.should == 3.6
    first_data.logged_at.should == Time.at(1380060002)
  end
end
