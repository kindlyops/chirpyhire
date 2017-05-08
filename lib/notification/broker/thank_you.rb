class Notification::Broker::ThankYou < Notification::Broker::Base
  def body
    <<~BODY
      Ok. Great! We're all set. Now, let us get you the right opportunity!
    BODY
  end
end
