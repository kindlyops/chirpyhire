class Bot::GoalTrigger
  def self.call(goal, message, campaign_contact)
    new(goal, message, campaign_contact).call
  end

  def initialize(goal, message, campaign_contact)
    @goal = goal
    @message = message
    @campaign_contact = campaign_contact
  end

  attr_reader :goal, :message, :campaign_contact
  delegate :contact, :phone_number, to: :campaign_contact
  delegate :organization, to: :contact
  delegate :team, to: :assignment_rule

  def call
    tag_and_broadcast
    notify_team
    campaign_contact.update(state: :exited)
    close_conversation

    goal.body
  end

  def notify_team
    notify_contact_ready_for_review(team.accounts, message.conversation)
  end

  def assignment_rule
    organization.assignment_rules.find_by(phone_number: phone_number)
  end

  def notify_contact_ready_for_review(accounts, conversation)
    accounts.find_each do |account|
      Texter::Notification.new(account, conversation).contact_ready_for_review
      ready_for_review_mailer(account, conversation).deliver_later
    end
  end

  def ready_for_review_mailer(account, conversation)
    NotificationMailer.contact_ready_for_review(account, conversation)
  end

  def tag_and_broadcast
    goal.tag(contact)
    Broadcaster::Contact.broadcast(contact)
  end

  def close_conversation
    message.conversation.close
    Broadcaster::Conversation.broadcast(message.conversation)
  end
end
