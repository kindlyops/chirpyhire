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
    @referral ||= referrer.refer(candidate, message)
  end

  def referral_notice
    Sms::Response.new do |r|
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

  def vcard_user
    @vcard_user ||= UserFinder.new(attributes: vcard.attributes).call
  end

  def candidate
    @candidate ||= organization.candidates.find_or_create_by(user: vcard_user)
  end

  def referrer
    @referrer ||= ReferrerFinder.new(organization: organization, sender: sender).call
  end
end
