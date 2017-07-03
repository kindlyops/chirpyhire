class Bot::FollowUpTrigger
  def self.call(follow_up, message, campaign_contact)
    new(follow_up, message, campaign_contact).call
  end

  def initialize(follow_up, message, campaign_contact)
    @follow_up = follow_up
    @message = message
    @campaign_contact = campaign_contact
  end

  def call
    return '' unless follow_up.activated?(message)

    tag_and_broadcast
    next_step_body
  end

  def next_step_body
    "#{follow_up.body}\n\n#{next_body}"
  end

  def next_body
    return trigger_next_question if follow_up.next_question?
    return trigger_goal if follow_up.goal?

    trigger_question
  end

  def trigger_goal
    return null_step if goal.blank?
    goal.trigger(message, campaign_contact)
  end

  def trigger_question
    return null_step if question.blank?
    question.trigger(message, campaign_contact)
  end

  def trigger_next_question
    return trigger_first_goal if next_question.blank?
    next_question.trigger(message, campaign_contact)
  end

  def next_question
    bot.question_after(campaign_contact.question)
  end

  def trigger_first_goal
    first_goal.trigger(message, campaign_contact)
  end

  attr_reader :follow_up, :message, :campaign_contact
  delegate :bot, :question, :goal, to: :follow_up
  delegate :first_goal, to: :bot
  delegate :contact, to: :campaign_contact

  private

  def tag_and_broadcast
    follow_up.tag(contact)
    Broadcaster::Contact.broadcast(contact)
  end

  def null_step
    ''
  end
end
