class FakeMessaging
  Message = Struct.new(:from, :to, :body, :sid)

  cattr_accessor :messages
  self.messages = []

  def initialize(_account_sid, _auth_token)
  end

  def messages
    self
  end

  def account
    self
  end

  def create(from:, to:, body:)
    message = Message.new(from, to, body, Faker::Lorem.word)
    self.class.messages << message
    message
  end
end

Messaging::Client.client = FakeMessaging
RSpec.configure do |config|
  config.before(:each) do
    FakeMessaging.messages = []
  end
end
