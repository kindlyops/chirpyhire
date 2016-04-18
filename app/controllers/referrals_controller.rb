class ReferralsController < SmsController

  def create
    render_sms referral.sms_response
  end

  private

  def referral
    if message.present? && referrer.present? && lead.present?
      referrer.referrals.create(lead: lead, message: message)
    else
      NullReferral.new
    end
  end

  def vcard_user
    @vcard_user ||= UserFinder.new(attributes: vcard.attributes).call
  end

  def lead
    @lead ||= organization.leads.find_or_create_by(user: vcard_user)
  end

  def referrer
    @referrer ||= ReferrerFinder.new(organization: organization, sender: sender).call
  end
end
