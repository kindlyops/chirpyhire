class Bot::Survey
  def initialize(bot, message, campaign_conversation)
    @bot = bot
    @message = message
    @campaign_conversation = campaign_conversation
  end

  attr_reader :message, :bot, :campaign_conversation

  def ask(welcome: false)
    return unless campaign_conversation.active?

    campaign_conversation.update!(question: next_question)
    send_message(next_question.body(welcome: welcome))
  end

  def next_question
    @next_question ||= question_after(question)
  end

  def restate
    return unless campaign_conversation.active?

    send_message(question.restated)
  end

  def complete
    return unless campaign_conversation.active?
    contact.update!(screened: true)
    campaign_conversation.update!(inquiry: nil, state: :complete)
    send_message(thank_you.body)
  end

  def just_finished?
    return unless campaign_conversation.active?

    last_question? && answer.valid?(message)
  end

  def last_question?
    return true if last_question.blank?
    ### Has highest rank of all questions in bot
  end

  delegate :question, to: :campaign_conversation
end
