class Surveyor
  def initialize(contact)
    @contact = contact
  end

  def start
    return thank_person unless candidacy.pending?

    lock_candidacy
    survey.ask
  end

  def consider_answer(inquiry, message)
    return unless survey.on?(inquiry)

    return complete_survey(message) if survey.just_finished?(message)
    return survey.restate unless survey.answer.valid?(message)

    update_candidacy(message)
    survey.ask
  end

  def survey
    @survey ||= Survey.new(candidacy)
  end

  private

  def complete_survey(message)
    update_candidacy(message)
    survey.complete
  end

  def send_message(message)
    organization.message(sender: CHIRPY, recipient: person, body: message)
  end

  def update_candidacy(message)
    survey.answer.format(message) do |formatted_answer|
      candidacy.assign_attributes(formatted_answer)
      candidacy.progress = candidacy.current_progress
      candidacy.save!
      Broadcaster::CandidacyProgress.new(candidacy).broadcast
    end
  end

  def lock_candidacy
    candidacy.update!(contact: contact, state: :in_progress)
  end

  def thank_person
    send_message(thank_you.body)
  end

  def thank_you
    Notification::ThankYou.new(contact)
  end

  attr_reader :contact

  delegate :person, :organization, to: :contact
  delegate :candidacy, to: :person
end
