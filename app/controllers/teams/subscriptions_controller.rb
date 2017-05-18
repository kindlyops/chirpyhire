class Teams::SubscriptionsController < Teams::MessagesController
  before_action :sync_message

  def create
    if contact.subscribed? && contact.candidacy.started?
      AlreadySubscribedJob.perform_later(contact)
    else
      contact.subscribe
      SurveyorJob.perform_later(contact)
    end
    head :ok
  end

  def destroy
    contact.unsubscribe if contact.subscribed?

    head :ok
  end

  private

  def contact
    @contact ||= begin
      contact = person.contacts.find_by(team: team)
      contact || create_unsubscribed_contact
    end
  end

  def create_unsubscribed_contact
    person.contacts.create(team: team).tap do |contact|
      IceBreakerJob.perform_later(contact)
    end
  end

  def sync_message
    MessageSyncerJob.perform_later(contact, params['MessageSid'])
  end
end