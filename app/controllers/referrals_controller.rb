class ReferralsController < SmsController
  before_action :require_sender

  def create
    render_sms referral.sms_response
  end

  private

  def referral
    return NullReferral.new unless referrer.present? && lead.present?
    referrer.referrals.create(lead: lead, message: message)
  end

  def lead
    @lead ||= LeadFinder.new(organization: organization, attributes: vcard.attributes).call
  end

  def referrer
    @referrer ||= ReferrerFinder.new(organization: organization, sender: sender).call
  end

  def require_sender
    error_message unless sender.present?
  end

  def vcard
    message.vcard
  end
end
