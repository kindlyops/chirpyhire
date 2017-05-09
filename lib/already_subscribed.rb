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
      body: already_subscribed
    )
  end

  private

  attr_reader :contact
  delegate :person, :organization, to: :contact

  def already_subscribed
    <<~BODY
      So great to hear from you!

      You are already subscribed so no need to worry!

      Is there anything we can help you with?

      Hope you're having a great day,

      The #{organization.name} Team
    BODY
  end
end
