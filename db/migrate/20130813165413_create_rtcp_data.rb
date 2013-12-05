class CreateRtcpData < ActiveRecord::Migration
  def change
    create_table :rtcp_data do |t|
      t.integer :test_run_id
      t.time :time
      t.float :max_packet_loss
      t.float :avg_packet_loss
      t.float :max_jitter
      t.float :avg_jitter

      t.timestamps
    end
  end
end
