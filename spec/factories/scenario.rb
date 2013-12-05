FactoryGirl.define do
  factory :scenario do
    name "My first scenario"
    sipp_xml "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> {{PCAP_AUDIO}}"
  end

  factory :sipp_scenario, parent: :scenario do
    sipp_xml "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>"
    sippy_cup_scenario nil
  end

  factory :sipp_scenario_with_pcap, parent: :sipp_scenario do
    pcap_audio { File.open(File.join(Rails.root, 'spec', 'fixtures', 'dtmf_2833_1.pcap')) }
  end

  factory :sippy_cup_scenario, parent: :scenario do
    sipp_xml nil
    sippy_cup_scenario "invite"
  end

  factory :sippy_cup_scenario_with_complete_manifest, parent: :scenario do
    sipp_xml nil
    sippy_cup_scenario "---\nsource: 18341:23492\ndestination: 180348:2390480\nname: SIPPY CUP\nsteps: \n  - invite"
  end
end
