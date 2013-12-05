require 'spec_helper'

describe "Test runs" do
  describe "GET /test_runs" do
    it "lists test_runs" do
      login_user
      get test_runs_path
      response.status.should be(200)
    end

    it "is unaccessible as a guest" do
      get test_runs_path
      response.status.should be(302)
    end
  end
end
