class Notification::Brokers::Welcome < Notification::Brokers::Base
  def body
    <<~BODY.strip
      Oh, wow! Excited to help you get work.
      This is Wayne, CEO of ChirpyHire. And yes, we're always happy!
      We're here to connect you with local caregiving opportunities.

      Are you ready? Let's get started.
    BODY
  end
end
