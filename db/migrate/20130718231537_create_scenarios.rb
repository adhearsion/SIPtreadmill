class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|
      t.string :name
      t.text :sipp_xml
      t.string :pcap_audio

      t.timestamps
    end
  end
end
