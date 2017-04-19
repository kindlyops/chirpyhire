class NotSubscribed
  def self.call(contact)
    new(contact).call
  end

  def initialize(contact)
    @contact = contact
  end

  def call
    organization.message(
      sender: Chirpy.person,
      recipient: contact.person,
      body: not_subscribed
    )
  end

  private

  attr_reader :contact
  delegate :person, :organization, to: :contact

  def not_subscribed
    'You were not subscribed to '\
    "#{organization.name}. To subscribe reply with 'START'."
  end
end
