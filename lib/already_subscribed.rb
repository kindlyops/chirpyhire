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
      contact: contact,
      body: already_subscribed
    )
  end

  private

  attr_reader :contact
  delegate :organization, to: :contact

  def already_subscribed
    <<~BODY
      Hey there!

      How can I help?

      Team #{organization.name}
    BODY
  end
end
