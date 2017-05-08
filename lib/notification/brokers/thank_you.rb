class Notification::Brokers::ThankYou < Notification::Brokers::Base
  def body
    <<~BODY
      Ok. Great! We're all set.

      Now, let us get you the right opportunity!

      We will be in touch.

      - Wayne
      CEO, ChirpyHire
    BODY
  end
end
