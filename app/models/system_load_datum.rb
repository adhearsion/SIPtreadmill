class SystemLoadDatum < ActiveRecord::Base
  attr_accessible :cpu, :memory, :test_run_id, :logged_at
  belongs_to :test_run
end
