class FakeMessaging
  MediaInstance = Struct.new(:content_type) do
    IMAGE_TYPES = %w(image/jpeg image/gif image/png image/bmp)

    def image?
      IMAGE_TYPES.include?(content_type)
    end
  end

  Media = Struct.new(:media_instances) do
    def list
      media_instances
    end
  end

  Message = Struct.new(:from, :to, :body, :media, :direction, :sid) do
    def num_media
      media.list.count.to_s
    end
  end

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

  def create(from:, to:, body:, direction: "outbound-api", format: :text)
    if format == :text
      media = Media.new([])
    elsif format == :image
      media = Media.new([MediaInstance.new("image/jpeg")])
    end

    message = Message.new(from, to, body, media, direction, Faker::Lorem.word)
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
