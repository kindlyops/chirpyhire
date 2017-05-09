class BrokerAlreadySubscribed
  def self.call(broker_contact)
    new(broker_contact).call
  end

  def initialize(broker_contact)
    @broker_contact = broker_contact
  end

  def call
    broker.message(
      sender: Chirpy.person,
      recipient: person,
      body: already_subscribed
    )
  end

  private

  attr_reader :broker_contact
  delegate :person, :broker, to: :broker_contact

  def already_subscribed
    <<~BODY
      So great to hear from you!

      You are already subscribed so no need to worry!

      Is there anything I can help you with?

      Hope you're having a great day,

      Chirpy
    BODY
  end
end
