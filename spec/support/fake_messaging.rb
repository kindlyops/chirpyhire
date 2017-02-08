class FakeMessaging
  cattr_accessor :messages
  self.messages = []

  def self.inbound_message(sender, organization, body = Faker::Lorem.word, format: :image)
    create(
      from: sender.phone_number,
      to: organization.phone_number,
      body: format == :text ? body : '',
      direction: 'inbound',
      format: format
    )
  end

  def self.non_existent_inbound_message(sender, organization, body = Faker::Lorem.word, format: :image)
    create_non_existent_message(
      from: sender.phone_number,
      to: organization.phone_number,
      body: format == :text ? body : '',
      direction: 'inbound',
      format: format
    )
  end

  def initialize(_account_sid, _auth_token); end

  def messages
    self
  end

  def account
    self
  end

  def get(sid)
    self.class.messages.find { |message| message.sid == sid }
  end

  def create(from:, to:, body:, direction: 'outbound-api', format: :image)
    self.class.create(from: from, to: to, body: body, direction: direction, format: format)
  end

  def self.create(from:, to:, body:, direction: 'outbound-api', format: :image)
    message = FakeMessage.new(from,
                              to,
                              body,
                              format,
                              direction,
                              Faker::Number.number(10),
                              exists: true)
    append_message(message)
  end

  private_class_method

  def self.create_non_existent_message(from:, to:, body:, direction: 'outbound-api', format: :image)
    message = FakeMessage.new(from,
                              to,
                              body,
                              format,
                              direction,
                              Faker::Number.number(10),
                              exists: false)
    append_message(message)
  end

  def self.append_message(message)
    messages << message
    message
  end
end

Messaging::Client.client = FakeMessaging
RSpec.configure { |config| config.before(:each) { FakeMessaging.messages = [] } }
