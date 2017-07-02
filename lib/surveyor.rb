class Surveyor
  def initialize(contact, message)
    @contact = contact
    @message = message
  end

  def start
    return unless contact_candidacy.pending?

    contact_candidacy.update!(state: :in_progress)
    survey.ask(welcome: true)
  end

  def consider_answer(inquiry)
    return unless survey.on?(inquiry)

    return complete_survey if survey.just_finished?
    return restate_and_log unless survey.answer.valid?(message)

    update_contact_candidacy
    survey.ask
  end

  def survey
    @survey ||= Survey.new(contact, message)
  end

  private

  def restate_and_log
    ReadReceiptsCreator.call(message, contact)

    survey.restate
  end

  def complete_survey
    update_contact_candidacy
    survey.complete

    notify_team
  end

  def notify_team
    notify_contact_ready_for_review(team.accounts, message.conversation)
  end

  def send_message(message_body)
    organization.message(
      sender: Chirpy.person,
      conversation: message.conversation,
      body: message_body
    )
  end

  def update_contact_candidacy
    survey.answer.format(message) do |formatted_answer|
      contact_candidacy.assign_attributes(formatted_answer)
      contact_candidacy.save!
      Tagger.call(contact, formatted_answer)
      Broadcaster::Contact.broadcast(contact)
      contact_candidacy
    end
  end

  def notify_contact_ready_for_review(accounts, conversation)
    accounts.find_each do |account|
      ready_for_review_mailer(account, conversation).deliver_later
    end
  end

  def ready_for_review_mailer(account, conversation)
    NotificationMailer.contact_ready_for_review(account, conversation)
  end

  def assignment_rule
    assignment_rules.find_by(phone_number: organization_phone_number)
  end

  attr_reader :contact, :message

  delegate :organization, :contact_candidacy, to: :contact
  delegate :assignment_rules, to: :organization
  delegate :team, to: :assignment_rule
  delegate :organization_phone_number, to: :message
end
