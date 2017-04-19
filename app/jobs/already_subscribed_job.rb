class AlreadySubscribedJob < ApplicationJob
  def perform(contact)
    AlreadySubscribed.call(contact)
  end
end
