class Notification::Brokers::ThankYou < Notification::Brokers::Base
  def body
    <<~BODY
      Hey there!

      It's Chirpy! Just wanted to thank you for taking the time to tell us a little more about yourself.

      As care providers express interest in you we'll reach back out and introduce you to great employers in your area!

      We'll be in touch!

      Keep on caring,

      Chirpy
    BODY
  end
end
