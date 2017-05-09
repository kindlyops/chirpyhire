class Notification::Brokers::Welcome < Notification::Brokers::Base
  def body
    <<~BODY.strip
      Hello! My name is Chirpy and I am a caregiver recruiter. It's great to meet you!

      I'm here to find you more shifts with the care providers you like.

      Here's how I do that. Over time, I'll text you questions to learn about your skills, preferences, and availability. There are no right answers so just be yourself!

      As I learn more about you, I'll find care providers that are a good fit and connect you with them.

      Are you ready? Let's get started.
    BODY
  end
end
