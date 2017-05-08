class BrokerAlreadySubscribedJob < ApplicationJob
  def perform(broker_contact)
    BrokerAlreadySubscribed.call(broker_contact)
  end
end
