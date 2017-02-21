class FakeMessage
  def initialize(from:, to:, body:)
    @from = from
    @to = to
    @body = body
  end

  attr_reader :body, :to, :from

  def sid
    "MESSAGE_SID_#{Message.last.id + 1}"
  end

  def date_sent
    DateTime.current
  end

  def direction
    'outbound-api'
  end

  def date_created
    DateTime.current
  end
end
