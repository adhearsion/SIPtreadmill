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

  def to_sippycup_scenario(opts = {})
    if sippy_cup_scenario.present?
      scenario = SippyCup::Scenario.new name, opts
      scenario.build sippy_cup_scenario_steps
      scenario
    else
      SippyCup::XMLScenario.new name, sipp_xml, pcap_data, opts
    end
  end

  def sippy_cup_scenario_steps
    sippy_cup_scenario.split("\n").map(&:chomp)
  end

  def writable?
    !(self.test_runs.count > 0)
  end

  def sippy_cup_scenario_must_be_valid
    if sippy_cup_scenario.present?
      scenario = SippyCup::Scenario.new(name, source: '127.0.0.1', destination: '127.0.0.1')
      scenario.build sippy_cup_scenario_steps
      unless scenario.valid?
        scenario.errors.each do |err|
          errors.add(:sippy_cup_scenario, "#{err[:message]} (Step #{err[:step]})")
        end
      end
    end
  end

  private

  def pcap_data
    File.read(pcap_audio.url) if pcap_audio.url
  end
end
