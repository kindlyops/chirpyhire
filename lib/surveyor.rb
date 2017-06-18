class Surveyor
  def initialize(contact)
    @contact = contact
  end

  def start
    if candidacy.complete?
      contact.update(screened: true)
      send_message(complete_welcome.body)
      notify_team
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

  def restate_and_log(message)
    ReadReceiptsCreator.call(message, contact)

    survey.restate
  end

  def complete_survey(message)
    update_candidacy(message)
    survey.complete

    notify_all_teams
  end

  def notify_team
    notify_contact_ready_for_review(team.accounts, contact.open_conversation)
  end

  def notify_all_teams
    person.teams.find_each do |team|
      contact = team.contacts.find_by(person: person)
      conversation = contact.open_conversation
      notify_contact_ready_for_review(team.accounts, conversation)
    end
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

  def notify_contact_ready_for_review(accounts, conversation)
    accounts.find_each do |account|
      ready_for_review_mailer(account, conversation).deliver_later
    end
  end

  def ready_for_review_mailer(account, conversation)
    NotificationMailer.contact_ready_for_review(account, conversation)
  end

  def complete_welcome
    Notification::CompleteWelcome.new(contact)
  end

  attr_reader :contact

  delegate :person, :organization, :team, to: :contact
  delegate :candidacy, to: :person
end
