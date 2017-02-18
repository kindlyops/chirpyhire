class Organizations::SubscriptionsController < Organizations::BaseController
  before_action :sync_message

  def create
    if person.lead_at?(organization)
      AlreadySubscribedJob.perform_later(person, organization)
    else
      person.leads.create!(organization: organization)
    end
    head :ok
  end

  def destroy
    if person.lead_at?(organization)
      person.lead_at(organization).unsubscribe!
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
