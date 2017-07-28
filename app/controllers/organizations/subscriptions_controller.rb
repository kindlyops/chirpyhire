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
    organization.contacts.find_by(phone_number: params['From'])
  end

  def create_unsubscribed_contact
    organization
      .contacts
      .create(contact_params)
  end

  def contact_params
    {
      person: Person.create(phone_number: params['From']),
      phone_number: params['From'],
      stage: organization.contact_stages.first
    }
  end

  def sync_message
    MessageSyncerJob.perform_later(contact, params['MessageSid'])
  end
end
