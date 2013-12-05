require 'spec_helper'
require 'socket'
require 'countdownlatch'

describe RTCPTools::Listener do
  let(:packet) { "\x81\xC8\x00\f\x18\x1D\xC0\x1C\xD5\xE6\xE4F\xA5\xEA\x06\xED\x00\x00\x9C@\x00\x00\x00\xFA\x00\x00\x9C@\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00e\xC6\xA5\xE3\x81\xCA\x00\x02\x18\x1D\xC0\x1C\x01\x00\x00\x00" }
  let(:time) { Time.new(2013,9,20,11,12,06,"-04:00") }
  context '#run' do
    
    it 'should read from the socket and parse data' do
      listener = RTCPTools::Listener.new 6000
      Thread.new { listener.run }
      UDPSocket.new.send packet, 0, 'localhost', 6000
      sleep 1
      listener.stop
      listener.data.should == { time => { jitter: [0], fractional_loss: [0.0] } }
      listener.organize_data.should == [{ time: time, avg_jitter: 0, max_jitter: 0, avg_packet_loss: 0.0, max_packet_loss: 0.0 }]
    end
  end
end
