class FakeMessaging
  Message = Struct.new(:from, :to, :body, :num_media, :sid)

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

  def get(sid)
    self.class.messages.find {|message| message.sid == sid }
  end

  def create(from:, to:, body:, num_media: 0)
    message = Message.new(from, to, body, num_media, Faker::Lorem.word)
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
