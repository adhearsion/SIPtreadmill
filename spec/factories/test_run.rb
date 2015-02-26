FactoryGirl.define do
  factory :test_run do
    name "My first test_run"
    user { FactoryGirl.build(:user) }
    scenario { FactoryGirl.build(:scenario, id: 1) }
    profile { FactoryGirl.build(:profile, id: 1) }
    target { FactoryGirl.build(:target, id: 1) }
    to_user '+14044754840'
    from_user 'sippppp'
    advertise_address '10.5.5.1'
    sipp_options 'p: "101"'
    errors_report_file { File.open(File.join(Rails.root, 'spec', 'fixtures', 'errors.txt')) }
    state 'pending'
  end
end
