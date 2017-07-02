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
    person.contacts.find_by(organization: organization)
  end

  def create_unsubscribed_contact
    person.contacts.create(organization: organization)
  end

  def sync_message
    MessageSyncerJob.perform_later(contact, params['MessageSid'])
  end
end
