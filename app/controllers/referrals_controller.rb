class ReferralsController < SmsController

  def create
    if referrer.present?
      referrer.refer(candidate)
      messaging_response = Messaging::Response.new(subject: candidate)

      render text: messaging_response.referral_notice
    else
      messaging_response = Messaging::Response.new(subject: sender)

      render text: messaging_response.no_referrer
    end
  end

  private

  def referred_user
    @referred_user ||= UserFinder.new(attributes: vcard.attributes, organization: organization).call
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
