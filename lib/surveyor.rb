class Surveyor
  def initialize(contact)
    @contact = contact
  end

  def start
    if candidacy.complete?
      notify_contact_ready_for_review(contact_team_inbox_conversations)
      contact.update(screened: true)
      send_message(complete_welcome.body)
    elsif candidacy.pending?
      lock_candidacy
      survey.ask
    end
  end

  def consider_answer(inquiry, message)
    return unless survey.on?(inquiry)

    return complete_survey(message) if survey.just_finished?(message)
    return restate_and_log(message) unless survey.answer.valid?(message)

    update_candidacy(message)
    survey.ask
  end

  def survey
    @survey ||= Survey.new(candidacy)
  end

  private

  def contact_team_inbox_conversations
    team.inbox_conversations.contact(contact)
  end

  def restate_and_log(message)
    ReadReceiptsCreator.call(message, contact)

    survey.restate
  end

  def complete_survey(message)
    update_candidacy(message)
    survey.complete

    notify_contact_ready_for_review(person_inbox_conversations)
  end

  def person_inbox_conversations
    account_ids = Membership.where(team: person.teams).pluck(:account_id)
    inbox_ids = Inbox.where(
      inboxable_type: 'Account',
      inboxable_id: account_ids
    ).pluck(:id)

    contact_ids = person.contacts.subscribed.pluck(:id)
    conversation_ids = Conversation.where(contact_id: contact_ids).pluck(:id)

    InboxConversation.where(
      inbox_id: inbox_ids, conversation_id: conversation_ids
    )
  end

  def send_message(message)
    organization.message(
      sender: Chirpy.person,
      contact: contact,
      body: message
    )
  end

  def update_candidacy(message)
    survey.answer.format(message) do |formatted_answer|
      candidacy.assign_attributes(formatted_answer)
      candidacy.save!
      Broadcaster::Contact.broadcast(contact)
      candidacy
    end
  end

  def lock_candidacy
    candidacy.update!(contact: contact, state: :in_progress)
  end

  def notify_contact_ready_for_review(inbox_conversations)
    inbox_conversations.find_each do |inbox_conversation|
      ready_for_review_mailer(inbox_conversation).deliver_later
    end
  end

  def ready_for_review_mailer(inbox_conversation)
    NotificationMailer.contact_ready_for_review(inbox_conversation)
  end

  def complete_welcome
    Notification::CompleteWelcome.new(contact)
  end

  attr_reader :contact

  delegate :person, :organization, :team, to: :contact
  delegate :candidacy, to: :person
end
