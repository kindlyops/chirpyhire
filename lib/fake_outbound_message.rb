class FakeOutboundMessage < FakeMessage
  def initialize(from:, to:, body:)
    @from = from
    @to = to
    @body = body
  end

  attr_reader :body, :to, :from

  def sid
    "MESSAGE_SID_#{sid_sequence}"
  end

  def direction
    'outbound-api'
  end
end
