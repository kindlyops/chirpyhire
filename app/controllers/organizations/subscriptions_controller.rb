class Organizations::SubscriptionsController < Organizations::MessagesController
  before_action :sync_message

  def create
    if person.subscribed_to?(organization)
      AlreadySubscribedJob.perform_later(person, organization)
    else
      SurveyorJob.perform_later(contact)
    end
    head :ok
  end

  def destroy
    if person.subscribed_to?(organization)
      person.subscribed_to(organization).unsubscribe!
    else
      NotSubscribedJob.perform_later(person, organization)
    end
    head :ok
  end

  private

  def contact
    @contact ||= begin
      contact = person.contacts.find_by(organization: organization)
      return contact if contact.present?
      create_contact
    end
  end

  def create_contact
    person.contacts.create(organization: organization).tap do |contact|
      IceBreakerJob.perform_later(contact)
    end
  end

  def sync_message
    MessageSyncerJob.perform_later(person, organization, params['MessageSid'])
  end
end
