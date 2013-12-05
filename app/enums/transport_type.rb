class TransportType < ClassyEnum::Base
end

class TransportType::U1 < TransportType
  def text
    'UDP Mono'
  end
end

class TransportType::Un < TransportType
  def text
    'UDP Multi'
  end
end

class TransportType::T1 < TransportType
  def text
    'TCP Mono'
  end
end

class TransportType::Tn < TransportType
  def text
    'TCP Multi'
  end
end
