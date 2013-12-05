require 'spec_helper'

describe RTCPTools do
  subject { RTCPTools }

  describe "#parse" do
    # Use a real RTCP packet to test
    let(:packet) { "\x81\xc8\x00\x0c\x42\x69\xc7\xa9\xd5\xa3\xd1\x94\x2a\x85\x77\xbf\x00\x00\x9c\x40\x00\x00\x00\xfa\x00\x00\x9c\x40\x40\xc1\x11\x06\x00\x00\x00\x00\x00\x00\x00\xfd\x00\x00\x00\x01\x00\x00\x00\x00\x53\x14\x2a\x7e\x81\xca\x00\x02\x42\x69\xc7\xa9\x01\x00\x00\x00" }
    it "should return the proper data" do
      subject.parse(packet).should == {time: Time.new(2013,07,31,14,10,28,"-04:00"), fractional_loss: 0.0, total_loss: 0, jitter: 1}
    end
  end

  describe "#parse_headers" do
    context "No padding, one repoort" do
      let(:headers) { "\x81".unpack("B8").first }
      it "should return proper values for version, padding, and number of reports" do
        subject.parse_headers(headers).should == { version: 2, padding: false, report_count: 1 }
      end
    end

    context "Padding, two reports" do
      let(:headers) { "\xA2".unpack("B8").first }
      it "should return proper values for version, padding, and number of reports" do
        subject.parse_headers(headers).should == { version: 2, padding: true, report_count: 2 }
      end
    end
  end
end
