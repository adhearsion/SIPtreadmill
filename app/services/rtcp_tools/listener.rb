require 'socket'

module RTCPTools
  class Listener
    attr_reader :data
    attr_accessor :running
    def initialize(port)
      @socket  = UDPSocket.new
      @socket.bind('', port)
      @data    = { }
      @running = true
    end

    def run
      while running?
        socket_set = IO.select [@socket], [], [], 3
        next unless socket_set
        socket = socket_set.first.first
        packet = socket.recvfrom_nonblock(1024).first
        if new_data = RTCPTools.parse packet
          t = new_data[:time]
          @data[t] ||= { }
          [:fractional_loss, :jitter].each do |k|
            @data[t][k] ||= []
            @data[t][k] << new_data[k]
          end
        end
      end
    end

    def organize_data
      organized_data = []
      @data.each do |time, stats|
        max_jitter = stats[:jitter].max
        avg_jitter = average stats[:jitter]
        max_loss   = stats[:fractional_loss].max
        avg_loss   = average stats[:fractional_loss]
        organized_data << { time: time, avg_jitter: avg_jitter, max_jitter: max_jitter,
                            avg_packet_loss: avg_loss, max_packet_loss: max_loss }
      end
      organized_data
    end

    def average(arr)
      arr.inject(:+).to_f / arr.length
    end

    def stop
      @running = false
      @socket.close
    end

    def running?
      @running
    end
  end
end
