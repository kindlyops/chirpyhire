class ReferralsController < SmsController

  before_action :ensure_referrer, only: :create

  def create
    if referral.valid?
      render_sms referral_notice
    else
      error_message
    end
  end

  private

  def referral
    @referral ||= referrer.refer(candidate)
  end

  def referral_notice
    Messaging::Response.new do |r|
      r.Message "Awesome! Please copy and text to #{candidate.first_name}:"
      r.Message "Hey #{candidate.first_name}. My home care agency, \
#{organization.name}, regularly hires caregivers. They \
treat me very well and have great clients. I think you \
would be a great fit here. Text START to #{organization.phone_number} \
to learn about opportunities."
    end
  end

  def ensure_referrer
    return error_message unless referrer.present?
  end

  def referred_user
    @referred_user ||= UserFinder.new(attributes: vcard.attributes.merge(organization: organization)).call
  end

  def candidate
    @candidate ||= begin
      return referred_user.candidate if referred_user.candidate.present?
      referred_user.create_candidate
    end
  end

  def referrer
    @referrer ||= referrers.find_by(user: user)
  end

  def referrers
    organization.referrers
  end

  def sender
    user.referrer
  end
end
