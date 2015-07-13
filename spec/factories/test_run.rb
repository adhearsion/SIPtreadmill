FactoryGirl.define do
  factory :test_run do
    name "My first test_run"
    user { FactoryGirl.build(:user) }
    scenario { FactoryGirl.build(:scenario) }
    profile { FactoryGirl.build(:profile) }
    target { FactoryGirl.build(:target) }
    to '+14044754840'
    from_user 'sippppp'
    advertise_address '10.5.5.1'
    sipp_options 'p: "101"'
    errors_report_file { File.open(File.join(Rails.root, 'spec', 'fixtures', 'errors.txt')) }
    state 'pending'
  end
end
