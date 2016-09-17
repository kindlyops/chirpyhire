# frozen_string_literal: true
module Sms
  class ReferralsController < Sms::BaseController
    def create
      if referrer.present?
        referrer.refer(candidate)
        sender.receive_message(body: thanks)
        sender.receive_message(body: notice)
      else
        sender.receive_message(body: not_referrer)
      end
      head :ok
    end

    private

    def vcard
      @vcard ||= Vcard.new(url: params['MediaUrl0'])
    end

    def thanks
      "Awesome! Please copy and text to #{candidate.first_name}:"
    end

    def notice
      "Hey #{candidate.first_name}. My home care agency, "\
      "#{organization.name}, regularly hires caregivers. They "\
      'treat me very well and have great clients. I think you '\
      "would be a great fit here. Text START to #{organization.phone_number} "\
      'to learn about opportunities.'
    end

    def not_referrer
      "Sorry you are not registered. Contact #{organization.name} "\
      'if you would like to join the referral program.'
    end

    def referred_user
      @referred_user ||= UserFinder.new(
        attributes: vcard.attributes,
        organization: organization
      ).call
    end

    def candidate
      @candidate ||= begin
        return referred_user.candidate if referred_user.candidate.present?
        referred_user.create_candidate
      end
    end

    def referrer
      @referrer ||= referrers.find_by(user: sender)
    end

    def referrers
      organization.referrers
    end
  end
end
