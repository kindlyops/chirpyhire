class FakeMessaging
  cattr_accessor :messages
  self.messages = []

  def initialize(_account_sid, _auth_token); end

  def messages
    self
  end

  def account
    self
  end

  def get(sid)
    FakeInboundMessage.new(sid: sid)
  end

  def create(from:, to:, body:)
    message = FakeOutboundMessage.new(from: from, to: to, body: body)
    self.class.messages << message
    message
  end
end
