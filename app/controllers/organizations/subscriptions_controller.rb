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

  def sync_message
    MessageSyncerJob.perform_later(contact, params['MessageSid'])
  end
end
