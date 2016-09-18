class FakeMessaging
  MediaInstance = Struct.new(:content_type, :uri) do
    IMAGE_TYPES = %w(image/jpeg image/gif image/png image/bmp)

    def image?
      IMAGE_TYPES.include?(content_type)
    end

    def sid
      Faker::Number.number(10)
    end
  end

  Media = Struct.new(:media_instances) do
    def list
      media_instances
    end
  end

  Message = Struct.new(:from, :to, :body, :media, :direction, :date_sent, :date_created, :sid, :exists) do
    def num_media
      if exists.nil? || exists
        media.list.count.to_s
      else
        raise Twilio::REST::RequestError, "I don't exist."
      end
    end

    def media_urls
      if exists.nil? || exists
        media.list.map(&:uri)
      else
        raise Twilio::REST::RequestError, "I don't exist."
      end
    end

    def address
      if exists.nil? || exists
        @address ||= AddressFinder.new(body)
      else
        raise Twilio::REST::RequestError, "I don't exist."
      end
    end
  end

  cattr_accessor :messages
  self.messages = []

  def self.inbound_message(sender, organization, body = Faker::Lorem.word, format: :image, exists: true)
    body = format == :text ? body : ""

    new("foo", "bar").create(
      from: sender.phone_number,
      to: organization.phone_number,
      body: body,
      direction: "inbound",
      format: format,
      exists: exists
    )
  end

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

  def create(from:, to:, body:, direction: "outbound-api", format: :image, exists: true)
    if format == :text
      media = Media.new([])
    elsif format == :image
      media = Media.new([MediaInstance.new("image/jpeg", "/example/path/to/image.png")])
    end

    message = Message.new(from, to, body, media, direction, DateTime.current, DateTime.current, Faker::Number.number(10), exists)
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
