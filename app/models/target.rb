class Target < ActiveRecord::Base
  attr_accessible :address, :name, :ssh_username
  belongs_to :user
  has_many :test_runs

  validates_presence_of :name, :address
  validates_uniqueness_of :name, scope: :user_id
end
