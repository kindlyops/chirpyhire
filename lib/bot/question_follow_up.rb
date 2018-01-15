class Bot::QuestionFollowUp
  def self.call(question, message, campaign_contact)
    new(question, message, campaign_contact).call
  end

  def initialize(question, message, campaign_contact)
    @question = question
    @message = message
    @campaign_contact = campaign_contact
  end

  attr_reader :question, :message, :campaign_contact
  delegate :bot, :follow_ups, to: :question

  def call
    return null_response if follow_ups.blank?
    return restate_question if follow_up.blank?

    follow_up.trigger(message, campaign_contact)
  end

  def null_response
    log_message
    ''
  end

  def restate_question
    log_message
    question.restated
  end

  def log_message
    ReadReceiptsCreator.call(message, campaign_contact.contact)
  end

  def follow_up
    @follow_up ||= begin
      follow_ups
        .with_deleted
        .order('follow_ups.deleted_at NULLS FIRST')
        .find { |follow_up| follow_up.activated?(message) }
    end
  end
end
