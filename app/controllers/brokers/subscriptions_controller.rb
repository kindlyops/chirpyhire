class Brokers::SubscriptionsController < Brokers::BaseController
  before_action :sync_message

  def create
    if broker_contact.subscribed?
      BrokerAlreadySubscribedJob.perform_later(broker_contact)
    else
      broker_contact.subscribe
      BrokerSurveyorJob.perform_later(broker_contact)
    end
    head :ok
  end

  def destroy
    if broker_contact.subscribed?
      broker_contact.unsubscribe
    else
      BrokerNotSubscribedJob.perform_later(broker_contact)
    end
    head :ok
  end

  private

  def broker_contact
    @broker_contact ||= begin
      broker_contact = person.broker_contacts.find_by(broker: broker)
      return broker_contact if broker_contact.present?
      create_unsubscribed_broker_contact
    end
  end

  def create_unsubscribed_broker_contact
    person.broker_contacts.create(broker: broker)
  end

  def sync_message
    BrokerMessageSyncerJob.perform_later(broker_contact, params['MessageSid'])
  end
end
