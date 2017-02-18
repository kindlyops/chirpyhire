class Organizations::SubscriptionsController < Organizations::BaseController
  before_action :sync_message

  def create
    if person.subscribed_to?(organization)
      AlreadySubscribedJob.perform_later(person, organization)
    else
      person.subscribers.create!(organization: organization)
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
    MessageSyncerJob.perform_later(person, organization, params['MessageSid'])
  end
end
