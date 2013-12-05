require 'spec_helper'

describe "Scenarios" do
  describe "GET /test_runs" do
    let(:test_run_id) { 1 }
    before do
      FactoryGirl.create(:scenario, id: test_run_id)
    end

    it "has the placeholder text" do
      login_user
      get new_scenario_path
      response.status.should be(200)
      response.body.should match("Use {{PCAP_AUDIO}} as a placeholder for the PCAP file path in the XML.")
    end
  end
end
