class FakeInboundMessage < FakeMessage
  def initialize(sid: "MESSAGE_SID_#{sid_sequence}")
    @sid = sid
  end

  def direction
    'inbound'
  end

  def from
    Faker::PhoneNumber.cell_phone
  end

  def to
    Faker::PhoneNumber.cell_phone
  end

  def body
    'body'
  end
end
