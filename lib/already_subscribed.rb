class AlreadySubscribed
  def self.call(person, organization)
    new(person, organization).call
  end

  def initialize(person, organization)
    @person = person
    @organization = organization
  end

  def call
    organization.message(recipient: person, body: already_subscribed)
  end

  private

  attr_reader :person, :organization

  def already_subscribed
    'You are already subscribed. '\
    "Thanks for your interest in #{organization.name}."
  end
end
