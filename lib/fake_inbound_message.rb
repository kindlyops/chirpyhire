class FakeInboundMessage < FakeMessage
  def initialize(sid: "MESSAGE_SID_#{sid_sequence}")
    @sid = sid
  end

  def direction
    'inbound'
  end

  def from
    '+14041234567'
  end

  def to
    ENV.fetch('DEMO_ORGANIZATION_PHONE')
  end

  def body
    'body'
  end
end
