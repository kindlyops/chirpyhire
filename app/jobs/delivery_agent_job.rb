class DeliveryAgentJob < ApplicationJob
  def perform(contact, message_sid, question = nil)
    message = MessageSyncer.call(contact, message_sid)

    DeliveryAgent.call(message, question)
  end
end
