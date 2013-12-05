FactoryGirl.define do
  factory :test_run do
    name "My first test_run"
    user { FactoryGirl.build(:user) }
    scenario { FactoryGirl.build(:scenario, id: 1) }
    profile { FactoryGirl.build(:profile, id: 1) }
    target { FactoryGirl.build(:target, id: 1) }
    state 'pending'
  end
end