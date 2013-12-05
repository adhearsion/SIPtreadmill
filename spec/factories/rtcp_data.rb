# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rtcp_datum, :class => 'RtcpData' do
    test_run_id 1
    time "2013-08-13 12:54:13"
    max_packet_loss 1.5
    avg_packet_loss 1.5
    max_jitter 1.5
    avg_jitter 1.5
  end
end