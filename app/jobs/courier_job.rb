class CourierJob < ApplicationJob
  def perform(contact, message_sid)
    message = MessageSyncer.call(contact, message_sid)

    Courier.call(contact, message)
  end
end
