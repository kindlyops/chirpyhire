class FakeInboundMessage < FakeMessage
  def initialize(sid: "MESSAGE_SID_#{sid_sequence}")
    @sid = sid
  end

  def direction
    'inbound'
  end

  def from
    'from'
  end

  def to
    'to'
  end

  def body
    'body'
  end
end
