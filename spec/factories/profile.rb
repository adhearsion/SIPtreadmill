FactoryGirl.define do
  factory :profile do
    name "My first profile"
    calls_per_second 5
    max_calls 100
    max_concurrent 10
    transport_type "u1"
  end
end
