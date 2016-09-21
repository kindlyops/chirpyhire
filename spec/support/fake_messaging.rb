class FakeMessaging
  MediaInstance = Struct.new(:content_type, :uri) do
    def image?
      %w(image/jpeg image/gif image/png image/bmp).include?(content_type)
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

  cattr_accessor :messages
  self.messages = []

  def self.inbound_message(sender, organization, body = Faker::Lorem.word, format: :image)
    body = format == :text ? body : ''

    new('foo', 'bar').create(
      from: sender.phone_number,
      to: organization.phone_number,
      body: body,
      direction: 'inbound',
      format: format
    )
  end

  def self.non_existent_inbound_message(sender, organization, body = Faker::Lorem.word, format: :image)
    body = format == :text ? body : ''

    new('foo', 'bar').create_non_existent_message(
      from: sender.phone_number,
      to: organization.phone_number,
      body: body,
      direction: 'inbound',
      format: format
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
    self.class.messages.find { |message| message.sid == sid }
  end

  # rubocop:disable Metrics/MethodLength
  def create(from:, to:, body:, direction: 'outbound-api', format: :image)
    media = build_media(format)

    message = FakeMessage.new(from,
                              to,
                              body,
                              media,
                              direction,
                              DateTime.current,
                              DateTime.current,
                              Faker::Number.number(10),
                              exists: true)
    append_message(message)
  end

  def create_non_existent_message(from:, to:, body:, direction: 'outbound-api', format: :image)
    media = build_media(format)

    message = FakeMessage.new(from,
                              to,
                              body,
                              media,
                              direction,
                              DateTime.current,
                              DateTime.current,
                              Faker::Number.number(10),
                              exists: false)
    append_message(message)
  end
  # rubocop:enable Metrics/MethodLength

  private

  def append_message(message)
    self.class.messages << message
    message
  end

  def build_media(format)
    if format == :text
      Media.new([])
    elsif format == :image
      Media.new([MediaInstance.new('image/jpeg', '/example/path/to/image.png')])
    end
  end
end

Messaging::Client.client = FakeMessaging
RSpec.configure { |config| config.before(:each) { FakeMessaging.messages = [] } }
