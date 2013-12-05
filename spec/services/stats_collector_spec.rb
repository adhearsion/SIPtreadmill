require 'spec_helper'

describe StatsCollector do
  let(:vm_buffer) { [] }
  let(:opts) do
    {
      host: '127.0.0.1',
      user: 'vagrant',
      password: 'vagrant',
      interval: 1,
      vm_buffer: vm_buffer
    }
  end

  describe '#initialize' do
    it 'raises if the host required option is missing' do
      opts.delete(:host)
      expect { StatsCollector.new opts }.to raise_error ArgumentError, 'Must provide host!'
    end
  end

  describe '#run' do
    subject { StatsCollector.new opts }
    let(:test_run) { FactoryGirl.create :test_run }

    it "collects data" do
      Thread.new do
        sleep 3
        subject.stop
      end
      subject.run

      parser = VMStatParser.new vm_buffer, test_run
      parser.parse
      test_run.system_load_data.count.should > 0

      first_data = test_run.system_load_data.first
      first_data.memory.should > 0
    end
  end
end
