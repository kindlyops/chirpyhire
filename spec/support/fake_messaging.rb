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
    log(message)
    message
  end

  def log(message)
    File.write("default.yml", append(message))
  end

  def file
    @file ||= File.open("default.yml", "a+")
  end

  def yaml
    @yaml ||= begin
      yaml = YAML.load(file) || []
      file.close
      yaml
    end
  end

  def append(message)
    YAML.dump(yaml << message)
  end
end

Messaging::Client.client = FakeMessaging
RSpec.configure do |config|
  config.before(:each) do
    FakeMessaging.messages = []
  end
end
