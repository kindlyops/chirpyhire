class BrokerNotSubscribedJob < ApplicationJob
  def perform(contact)
    BrokerNotSubscribed.call(contact)
  end
end
