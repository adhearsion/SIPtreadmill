require 'spec_helper'

WebMock.allow_net_connect!

describe "Test runs", :js => true do
  # Wait for form-submission JS to load.
  # AJAX forms submitted before this loads will cause tests to fail for odd reasons.
  # This mostly impacts forms not present on the page at initial load - those in modals.
  def prepare_for_form_submission
    sleep 1
  end

  describe "GET /test_runs/new" do
    before do
      login_with_oauth
      visit new_test_run_path
    end

    it "show the new test run form" do
      page.should have_content("New Test Run")
    end

    context "choosing to create a new scenario" do
      before { select "Create new...", from: :test_run_scenario_id }

      it "opens the new scenario form" do
        page.should have_content("New Scenario")
      end

      describe "submitting the form empty" do
        before do
          prepare_for_form_submission
          click_button "Create Scenario"
        end

        it "has an error" do
          page.should have_content("Please review the problems below")
        end

        it "has an error for the blank field" do
          page.should have_content("can't be blank")
        end
      end
    end

    context "choosing to create a new profile" do
      before { select "Create new...", from: :test_run_profile_id }

      it "opens the new profile form" do
        page.should have_content("New Profile")
      end

      it "has an error if submitted as empty" do
        prepare_for_form_submission
        click_button "Create Profile"
        page.should have_content("Please review the problems below")
      end
    end

    context "choosing to create a new target" do
      before { select "Create new...", from: :test_run_target_id }

      it "opens the new target form" do
        page.should have_content("New Target")
      end

      it "has an error if submitted as empty" do
        prepare_for_form_submission
        click_button "Create Target"
        page.should have_content("Please review the problems below")
      end
    end

  end
end
