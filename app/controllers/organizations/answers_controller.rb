class Organizations::AnswersController < Organizations::MessagesController
  def create
    SurveyorAnswerJob.perform_later(contact, inquiry, params['MessageSid'])

    head :ok
  end

  private

  def inquiry
    contact.person_inquiry
  end

  def contact
    person.contacts.find_or_create_by(organization: organization)
  end
end
