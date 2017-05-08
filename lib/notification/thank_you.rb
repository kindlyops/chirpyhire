class Notification::ThankYou < Notification::Base
  def body
    <<~BODY
      Ok. Great! We're all set. Now, let us get you the right opportunity!

      If you don't hear back in a day or two, would you please text us back??

      We are incredibly busy helping caregivers help more families!
    BODY
  end
end
