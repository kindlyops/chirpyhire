class AlreadySubscribedJob < ApplicationJob
  def perform(person, organization)
    AlreadySubscribed.call(person, organization)
  end
end
