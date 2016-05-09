class MessageFinder
  def self.call(user, attributes)
    new(user: user, attributes: attributes).call
  end

  def initialize(user:, attributes:)
    @user = user
    @attributes = attributes
  end

  def call
    message = user.messages.find_by(sid: attributes["MessageSid"])
    if message.blank?
      message = user.messages.create(sid: attributes["MessageSid"], properties: attributes)
    end
    message
  end

  private

  attr_reader :attributes, :user
end
