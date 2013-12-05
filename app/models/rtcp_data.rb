class RtcpData < ActiveRecord::Base
  attr_accessible :avg_jitter, :avg_packet_loss, :max_jitter, :max_packet_loss, :test_run, :time
  belongs_to :test_run
end
