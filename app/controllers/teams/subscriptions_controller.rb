class Teams::SubscriptionsController < Teams::MessagesController
  def create
    if contact.subscribed? && contact.started?
      already_subscribed_job
    else
      contact.subscribe
      surveyor_job
    end
    head :ok
  end

  def destroy
    sync_message
    contact.unsubscribe if contact.subscribed?

    head :ok
  end

  private

  def contact
    @contact ||= begin
      contact = find_contact
      contact || create_unsubscribed_contact
    end
  end

  def find_contact
    contact = person.contacts.find_by(team: team)
    contact.update(screened: true) if contact && contact.complete?
    contact
  end

  def create_unsubscribed_contact
    person.contacts.create(team: team).tap(&:create_contact_candidacy)
  end

  def already_subscribed_job
    AlreadySubscribedJob.perform_later(contact, params['MessageSid'])
  end

  def surveyor_job
    SurveyorJob.perform_later(contact, params['MessageSid'])
  end

  def sync_message
    MessageSyncerJob.perform_later(contact, params['MessageSid'])
  end
end
