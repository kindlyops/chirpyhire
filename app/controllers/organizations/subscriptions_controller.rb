class Organizations::SubscriptionsController < Organizations::MessagesController
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
      contact = person.contacts.find_by(organization: organization)
      add_to_team(contact || create_unsubscribed_contact)
    end
  end

  def add_to_team(contact)
    return contact if contact.team.present?
    team = TeamCreator.call(organization)
    team.contacts << contact
    contact
  end

  def create_unsubscribed_contact
    person.contacts.create(organization: organization).tap do |contact|
      IceBreakerJob.perform_later(contact)
    end
  end

  def sync_message
    MessageSyncerJob.perform_later(contact, params['MessageSid'])
  end
end
