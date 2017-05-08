class Brokers::SubscriptionsController < Brokers::MessagesController
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
    broker_contact.unsubscribe if broker_contact.subscribed?

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
