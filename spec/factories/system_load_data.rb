# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_load_datum, :class => 'SystemLoadDatum' do
    test_run_id 1
    cpu 1.5
    memory 1
    logged_at "2013-08-13 13:16:03"
  end
end
