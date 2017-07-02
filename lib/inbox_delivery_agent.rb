class InboxDeliveryAgent
  def self.call(inbox, message)
    new(inbox, message).call
  end

  def initialize(inbox, message)
    @inbox = inbox
    @message = message
  end

  attr_reader :message, :inbox

  def call
    return active_bot.receive(message) if active_bot.present?
    return activated_bot.receive(message) if activated_bot.present?

    ReadReceiptsCreator.call(message, contact)
  end

  private

  def activated_bot
    @activated_bot ||= begin
      bots.find { |bot| bot.activated?(message) }
    end
  end

  delegate :conversation, :contact, to: :message
  delegate :active_bot, to: :conversation
  delegate :bots, to: :inbox
end
