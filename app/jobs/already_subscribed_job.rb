class AlreadySubscribedJob < ApplicationJob
  def perform(contact, message_sid)
    MessageSyncer.call(contact, message_sid)

    AlreadySubscribed.call(contact)
  end
end
