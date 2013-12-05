module RTCPTools
  class << self
    def parse(packet)
      headers, @packet = packet.unpack "B8 A*"
      headers = parse_headers headers
      return nil unless headers[:version] == 2

      type, @packet = @packet.unpack "C1 A*"
      return nil unless type.to_i == 200

      length, @packet = @packet.unpack "S>1 A*"

      ssrc, @packet = @packet.unpack "H8 A*"
      ts_seconds, @packet = @packet.unpack "L>1 A*"
      time = convert_ntp_epoch ts_seconds
      ts_fraction, @packet = @packet.unpack "L>1 A*"

      rtp_timestamp, @packet             = @packet.unpack "L>1 A*"
      packet_count, octet_count, @packet = @packet.unpack "L>1 L>1 A*"

      source_ssrc, @packet = @packet.unpack "H8 A*"
      floss, @packet       = @packet.unpack "C1 A*"
      fraction_loss        = calc_fraction_loss floss

      tloss, @packet = @packet.unpack "B24 A*"
      total_loss     = calc_total_loss tloss

      sequence, @packet = @packet.unpack "L>1 A*"
      jitter, @packet   = @packet.unpack "L>1 A*"

      { time: time, fractional_loss: fraction_loss, total_loss: total_loss, jitter: jitter }
    end

    def parse_headers(headers)
      version = headers.slice(0,2).to_i(2)
      padding = headers.slice(2,1).to_i == 1
      report_count = headers.slice(3,5).to_i(2)
      {version: version, padding: padding, report_count: report_count}
    end

    def convert_ntp_epoch(seconds)
      diff = Time.at(0) - Time.utc(1900)
      seconds -= diff
      Time.at seconds
    end

    def calc_fraction_loss(loss)
      loss.to_f / 256
    end

    def calc_total_loss(loss)
      zero_byte = "0" * 8
      total_loss = zero_byte << loss
      total_loss.to_i(2)
    end

  end
end
