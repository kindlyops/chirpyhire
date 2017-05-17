class AlreadySubscribed
  def self.call(contact)
    new(contact).call
  end

  def initialize(contact)
    @contact = contact
  end

  def call
    organization.message(
      sender: Chirpy.person,
      recipient: person,
      from: from,
      body: already_subscribed
    )
  end

  private

  def from
    contact.team.phone_number if contact.team.present?
    organization.phone_number
  end

  attr_reader :contact
  delegate :person, :organization, to: :contact

  def already_subscribed
    <<~BODY
      Hey there!

      How can I help?

      Team #{organization.name}
    BODY
  end
end
