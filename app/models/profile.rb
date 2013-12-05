class Profile < ActiveRecord::Base
  classy_enum_attr :transport_type, default: 'u1'
  attr_accessible :calls_per_second, :max_calls, :max_concurrent, :name, :transport_type
  belongs_to :user
  has_many :test_runs

  validates_presence_of :name, :calls_per_second, :max_calls, :max_concurrent, :transport_type
  validates_uniqueness_of :name, scope: :user_id

  def writable?
    self.test_runs.count == 0
  end
end
