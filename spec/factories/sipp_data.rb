# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sipp_datum, :class => 'SippData' do
    test_run_id 1
    time "2013-08-13 13:16:03"
    successful_calls 1
    failed_calls 1
    total_calls 1
    cps 1.5
    concurrent_calls 1
    avg_call_duration 1.5
  end
end
