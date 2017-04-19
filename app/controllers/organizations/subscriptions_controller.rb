class Organizations::SubscriptionsController < Organizations::MessagesController
  before_action :sync_message

  def create
    if contact.subscribed?
      AlreadySubscribedJob.perform_later(contact)
    else
      contact.subscribe
      SurveyorJob.perform_later(contact)
    end
    head :ok
  end

  def destroy
    if contact.subscribed?
      contact.unsubscribe
    else
      NotSubscribedJob.perform_later(contact)
    end
    head :ok
  end

  private

  def sync_message
    MessageSyncerJob.perform_later(contact, params['MessageSid'])
  end
end
