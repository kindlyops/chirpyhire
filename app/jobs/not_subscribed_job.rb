class NotSubscribedJob < ApplicationJob
  def perform(contact)
    NotSubscribed.call(contact)
  end
end
