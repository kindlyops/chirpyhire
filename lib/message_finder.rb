class MessageFinder
  def self.call(sender, attributes)
    new(sender: sender, attributes: attributes).call
  end

  def initialize(sender:, attributes:)
    @sender = sender
    @attributes = attributes
  end

  def call
    message = sender.messages.find_by(sid: attributes["MessageSid"])
    if message.blank?
      sender.messages.create(sid: attributes["MessageSid"], properties: attributes)
    end
  end

  private

  attr_reader :attributes, :sender
end
