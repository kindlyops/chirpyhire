class AlreadySubscribedJob < ApplicationJob
  def perform(contact, message_sid)
    message = MessageSyncer.call(contact, message_sid)

    AlreadySubscribed.call(contact, message)
  end
end
