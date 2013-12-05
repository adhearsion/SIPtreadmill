require 'open-uri'
require 'sippy_cup'

class Scenario < ActiveRecord::Base
  PCAP_PLACEHOLDER = '{{PCAP_AUDIO}}'

  attr_accessible :name, :sipp_xml, :pcap_audio, :pcap_audio_cache, :sippy_cup_scenario, :csv_data, :receiver, :description
  belongs_to :user
  has_many :test_runs
  has_one :registration_scenario, class_name: "Scenario"

  mount_uploader :pcap_audio, PcapAudioUploader

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :user_id

  validate :sippy_cup_scenario_must_be_valid

  def to_disk(dir, prefix, options = {})
    FileUtils.mkdir_p dir

    if sippy_cup_scenario.present?
      opts = options.merge name: name, filename: File.join(dir, prefix)
      SippyCup::Scenario.from_manifest(sippy_cup_scenario, opts).compile!
    else
      # TODO: We can't use File.write here because FakeFS hasn't released support for it yet: https://github.com/defunkt/fakefs/issues/155
      pcap_file_path = File.join(dir, "#{prefix}.pcap")
      dump_pcap pcap_file_path if pcap_audio.present?
      write_to_disk File.join(dir, "#{prefix}.xml"), sipp_xml.gsub(PCAP_PLACEHOLDER, pcap_file_path)
      write_to_disk File.join(dir, "#{prefix}.csv"), csv_data if csv_data.present?
    end
  end

  def writable?
    !(self.test_runs.count > 0)
  end

  def sippy_cup_scenario_must_be_valid
    if sippy_cup_scenario.present?
      scenario = SippyCup::Scenario.new(name, source: '127.0.0.1', destination: '127.0.0.1')
      scenario.build(sippy_cup_scenario.split("\n"))
      unless scenario.valid?
        scenario.errors.each do |err|
          errors.add(:sippy_cup_scenario, "#{err[:message]} (Step #{err[:step]})")
        end
      end
    end
  end

  private

  def write_to_disk(filename, content, mode = 'w')
    File.open(filename, mode) { |f| f.write content }
  end

  def dump_pcap(path)
    open pcap_audio.url do |f|
      write_to_disk path, f.read, 'wb'
    end
  end
end
