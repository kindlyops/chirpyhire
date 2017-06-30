class CourierJob < ApplicationJob
  def perform(contact, message_sid)
    Courier.call(contact, message_sid)
  end
end
