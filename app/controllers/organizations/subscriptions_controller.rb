class Organizations::SubscriptionsController < Organizations::MessagesController
  def destroy
    sync_message
    contact.unsubscribe if contact.subscribed?

    head :ok
  end

  private

  def contact
    @contact ||= begin
      find_contact || create_unsubscribed_contact
    end
  end

  def find_contact
    contact = person.contacts.find_by(organization: organization)
    contact.update(screened: true) if contact && contact.complete?
    contact
  end

  def create_unsubscribed_contact
    person
      .contacts
      .create(organization: organization)
      .tap(&:create_contact_candidacy)
  end

  def sync_message
    MessageSyncerJob.perform_later(contact, params['MessageSid'])
  end
end
