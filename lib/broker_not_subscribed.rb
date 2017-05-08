class BrokerNotSubscribed
  def self.call(broker_contact)
    new(broker_contact).call
  end

  def initialize(broker_contact)
    @broker_contact = broker_contact
  end

  def call
    broker.message(
      sender: Chirpy.person,
      recipient: broker_contact.person,
      body: not_subscribed
    )
  end

  private

  attr_reader :broker_contact
  delegate :person, :broker, to: :broker_contact

  def not_subscribed
    'You are not subscribed to '\
    "ChirpyHire. To subscribe reply with 'START'."
  end
end
