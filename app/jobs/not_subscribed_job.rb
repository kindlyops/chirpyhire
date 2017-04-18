class NotSubscribedJob < ApplicationJob
  def perform(person, organization)
    organization.message(
      sender: Chirpy.person,
      recipient: person,
      body: not_subscribed
    )
  end

  private

  def not_subscribed
    'You were not subscribed to '\
    "#{organization.name}. To subscribe reply with 'START'."
  end
end
