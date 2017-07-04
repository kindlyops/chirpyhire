class Bot::Greet
  def self.call(bot, message, campaign_contact)
    new(bot, message, campaign_contact).call
  end

  def initialize(bot, message, campaign_contact)
    @bot = bot
    @message = message
    @campaign_contact = campaign_contact
  end

  attr_reader :bot, :message, :campaign_contact
  delegate :first_active_question, to: :bot

  def call
    return null_greeting unless campaign_contact.pending?
    campaign_contact.update(state: :active)

    "#{bot.greeting.body}\n\n#{next_body}"
  end

  def null_greeting
    ''
  end

  def next_body
    next_step.trigger(message, campaign_contact)
  end

  def next_step
    first_active_question || goal
  end

  def goal
    bot.goals.first
  end
end
