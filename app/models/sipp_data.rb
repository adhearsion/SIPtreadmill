class SippData < ActiveRecord::Base
  attr_accessible :avg_call_duration, :avg_call_duration_cumulative, :concurrent_calls, :cps, :failed_calls, :failed_calls_cumulative, :response_time, :successful_calls, :successful_calls_cumulative, :test_run, :time, :total_calls
  belongs_to :test_run
end
