class Notification::Broker::ThankYou < Notification::Broker::Base
  def body
    <<~BODY
      Thanks for your interest in ChirpyHire!

      ...
    BODY
  end
end
