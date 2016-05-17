module Messaging
  class Response

    def initialize(subject:)
      @subject = subject
    end

    def error
      "Sorry I didn't understand that. Have a great day!"
    end

    def no_referrer
      "Sorry you are not registered. Contact #{organization_name} if you would like to join the referral program."
    end

    def subscription_notice
      "If you ever wish to stop receiving text messages from #{organization_name} just reply STOP."
    end

    def unsubscribed_notice
      "You are unsubscribed. To subscribe reply with START. Thanks for your interest in #{organization_name}."
    end

    def already_subscribed
      "You are already subscribed. Thanks for your interest in #{organization_name}."
    end

    def not_subscribed
      "You were not subscribed to #{organization_name}. To subscribe reply with START."
    end

    def referral_thanks
      "Awesome! Please copy and text to the subject:"
    end

    def referral_notice
      "Hey #{subject.first_name}. My home care agency, \
#{organization_name}, regularly hires caregivers. They \
treat me very well and have great clients. I think you \
would be a great fit here. Text START to #{organization_phone_number} \
to learn about opportunities."
    end

    private

    def organization_name
      subject.organization_name
    end

    def organization_phone_number
      subject.organization_phone_number
    end

    attr_reader :subject
  end
end
