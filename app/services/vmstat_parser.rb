class VMStatParser
  def initialize(buffer, test_run_instance)
    columns = ['pwait', 'psleep', 'swpd', 'free', 'inact', 'active', 'swpin', 'swpout', 'blocksin',
               'blocksout', 'interrupts', 'cs', 'user_cpu', 'sys_cpu', 'idle_cpu', 'wait_cpu']
    @columns = columns
    @test_run = test_run_instance
    @buffer = buffer
  end

  def parse
    @buffer.each {|l| parse_line l}
  end

  def parse_line(line)
    unless line =~ /^\s+r/ || line =~ /---/
      data = {}
      line, timestamp_part = line.split('|')
      timestamp = Time.at(timestamp_part.to_i)
      fields = line.split(/\s+/)
      fields.shift if fields[0].empty?
      @columns.each do |c|
        data[c] = fields.shift
      end
      cpu = data['user_cpu'].to_f + data['sys_cpu'].to_f + data['wait_cpu'].to_f
      memory = 100.0 - (data['free'].to_f / (data['free'].to_f + data['inact'].to_f + data['active'].to_f) * 100)

      params = { cpu: cpu, memory: memory.round(1), test_run_id: @test_run.id, logged_at: timestamp}
      SystemLoadDatum.create params
    end
  end
end
