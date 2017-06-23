class Surveyor
  def initialize(contact)
    @contact = contact
  end

  def start
    return unless contact_candidacy.pending?

    contact_candidacy.update!(state: :in_progress)
    survey.ask(welcome: true)
  end

  def consider_answer(inquiry, message)
    return unless survey.on?(inquiry)

    return complete_survey(message) if survey.just_finished?(message)
    return restate_and_log(message) unless survey.answer.valid?(message)

    update_contact_candidacy(message)
    survey.ask
  end

  def survey
    @survey ||= Survey.new(contact_candidacy)
  end

  private

  def restate_and_log(message)
    ReadReceiptsCreator.call(message, contact)

    survey.restate
  end

  def complete_survey(message)
    update_contact_candidacy(message)
    survey.complete

    notify_team
  end

  def notify_team
    notify_contact_ready_for_review(team.accounts, contact.open_conversation)
  end

  def send_message(message)
    organization.message(
      sender: Chirpy.person,
      contact: contact,
      body: message
    )
  end

  def update_contact_candidacy(message)
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

  attr_reader :contact

  delegate :organization, :team, :contact_candidacy, to: :contact
end
