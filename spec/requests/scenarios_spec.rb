require 'spec_helper'

describe "Scenarios" do
  describe "GET /test_runs" do
    it "has the placeholder text" do
      login_user
      get new_scenario_path
      response.status.should be(200)
      response.body.should match("Use {{PCAP_AUDIO}} as a placeholder for the PCAP file path in the XML.")
    end
  end
end
