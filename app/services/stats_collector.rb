require 'net/ssh'

class StatsCollector
  attr_accessor :running
  def initialize(opts={})
    [:host, :user, :password, :interval, :vm_buffer].each do |option|
      raise ArgumentError, "Must provide #{option}!" unless opts.keys.include? option
    end
    @opts = opts
  end

  def run
    @running = true
    Net::SSH.start(@opts[:host], @opts[:user], password: @opts[:password]) do |ssh|
      ssh.open_channel do |channel|
        channel.exec "vmstat -S M -a #{@opts[:interval]}" do |ch, success|
          unless success
            raise "CPU/Memory profiling failed!"
          end
          ch.on_data do |c, data|
            @opts[:vm_buffer] << "#{data}|#{Time.now.to_i}"
            unless @running
              c.close
            end
          end
        end
      end
    end
  end

  def stop
    @running = false
  end
end
