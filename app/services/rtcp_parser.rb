require 'json'

class RtcpParser
  def initialize(data, test_run_instance)
    @data, @test_run = data, test_run_instance
  end

  def run
    @data.each do |d|
      data = symbolize d
      data[:test_run] = @test_run
      RtcpData.create data
    end
  end

  def symbolize(h)
    sym_hash = {}
    h.each do |k,v|
      sym_hash[k.to_sym] = v
    end
    sym_hash
  end
end
