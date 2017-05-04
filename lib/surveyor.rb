class Surveyor
  def initialize(contact)
    @contact = contact
  end

  def start
    if candidacy.complete?
      notify_contact_ready_for_review(organization.conversations)
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
    ReadReceiptsCreator.call(message, organization)

    survey.restate
  end

  def complete_survey(message)
    update_candidacy(message)
    survey.complete
    notify_contact_ready_for_review(contact.person.conversations)
  end

  def send_message(message)
    organization.message(
      sender: Chirpy.person,
      recipient: person,
      body: message
    )
  end

  def update_candidacy(message)
    survey.answer.format(message) do |formatted_answer|
      candidacy.assign_attributes(formatted_answer)
      candidacy.save!
    end
  end

  def lock_candidacy
    candidacy.update!(contact: contact, state: :in_progress)
  end

  def notify_contact_ready_for_review(conversations)
    conversations.find_each do |conversation|
      NotificationMailer.contact_ready_for_review(conversation).deliver_later
    end
  end

  attr_reader :contact

  delegate :person, :organization, to: :contact
  delegate :candidacy, to: :person
end
