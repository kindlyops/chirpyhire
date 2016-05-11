module Messaging
  class Response

    def initialize(organization:)
      @organization = organization
    end

    def error
      "Sorry I didn't understand that. Have a great day!"
    end

    def subscription_notice
      "If you ever wish to stop receiving text messages from #{organization.name} just reply STOP."
    end

    def unsubscribed_notice
      "You are unsubscribed. To subscribe reply with START. Thanks for your interest in #{organization.name}."
    end

    def already_subscribed
      "You are already subscribed. Thanks for your interest in #{organization.name}."
    end

    def not_subscribed
      "You were not subscribed to #{organization.name}. To subscribe reply with START."
    end

    def referral_thanks
      "Awesome! Please copy and text to the candidate:"
    end

    def referral_notice
      "Hello! My home care agency, \
#{organization.name}, regularly hires caregivers. They \
treat me very well and have great clients. I think you \
would be a great fit here. Text START to #{organization.phone_number} \
to learn about opportunities."
    end

    private

    attr_reader :organization
  end
end
