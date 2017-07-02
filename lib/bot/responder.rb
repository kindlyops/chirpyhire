class Bot::Responder
  def self.call(bot, message, campaign_conversation)
    new(bot, message, campaign_conversation).call
  end

  def initialize(bot, message, campaign_conversation)
    @bot = bot
    @message = message
    @campaign_conversation = campaign_conversation
  end

  attr_reader :message, :bot, :campaign_conversation

  def call
    consider_answer if campaign_conversation.active?
    start if campaign_conversation.pending?
  end

  def start
    campaign_conversation.update(state: :active)
    survey.ask(welcome: true)
  end

  def consider_answer
    return complete_survey if survey.just_finished?
    return restate_and_log unless survey.answer.valid?

    update_contact
    survey.ask
  end

  def complete_survey
    update_contact
    survey.complete

    notify_team
  end

  def restate_and_log
    ReadReceiptsCreator.call(message, contact)
    
    survey.restate
  end

  def notify_team
    notify_contact_ready_for_review(team.accounts, message.conversation)
  end

  def notify_contact_ready_for_review(accounts, conversation)
    accounts.find_each do |account|
      ready_for_review_mailer(account, conversation).deliver_later
    end
  end

  def ready_for_review_mailer(account, conversation)
    NotificationMailer.contact_ready_for_review(account, conversation)
  end

  def survey
    @survey ||= begin
      Bot::Survey.new(bot, message, campaign_conversation)
    end
  end

  def reply
    organization.message(
      sender: bot.person,
      conversation: survey.conversation,
      body: survey.body
    )
  end

  def update_contact
    survey.answer.format do |formatted_answer|
      Tagger.call(contact, formatted_answer)
      Broadcaster::Contact.broadcast(contact)
    end
  end

  delegate :current_question, to: :campaign_conversation
  delegate :organization, to: :bot
  delegate :contact, to: :message
end
