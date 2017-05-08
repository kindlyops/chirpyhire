class Notification::Broker::ThankYou
  def initialize(broker_contact)
    @broker_contact = broker_contact
  end

  def body
    <<~BODY
      Thanks for your interest in ChirpyHire!

      ...
    BODY
  end

  attr_reader :broker_contact
end
