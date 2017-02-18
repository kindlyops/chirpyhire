class AlreadySubscribedJob < ApplicationJob
  def perform(person, organization)
    organization.message(recipient: person, body: already_subscribed)
  end

  private

  def already_subscribed
    'You are already subscribed. '\
    "Thanks for your interest in #{organization.name}."
  end
end
