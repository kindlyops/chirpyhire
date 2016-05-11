class ReferralsController < SmsController

  before_action :ensure_referrer, only: :create

  def create
    if referral.valid?
      AutomatonJob.perform_later(sender, referrer, "refer")
      head :ok
    else
      invalid_message
    end
  end

  private

  def referral
    @referral ||= referrer.refer(candidate)
  end

  def ensure_referrer
    return invalid_message unless referrer.present?
  end

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
