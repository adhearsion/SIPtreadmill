require 'json'

class RtcpParser
  def initialize(data, test_run_instance)
    @data, @test_run = data, test_run_instance
  end

  def run
    @data.each { |d| @test_run.rtcp_data.create d }
  end
end
