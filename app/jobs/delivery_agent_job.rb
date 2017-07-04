class DeliveryAgentJob < ApplicationJob
  def perform(contact, message_sid)
    message = MessageSyncer.call(contact, message_sid)

    DeliveryAgent.call(message)
  end
end
