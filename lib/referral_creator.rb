class ReferralCreator
  def initialize(message:, organization:, sender:)
    @message = message
    @organization = organization
    @sender = sender
  end

  def call
    return NullReferral.new unless referrer.present?

    lead.referrals.create(referrer: referrer, message: message)
  end

  attr_reader :message, :organization, :sender

  private

  def lead
    leads.find_or_create_by(user: lead_user)
  end

  def referrer
    referrers.find_by(user: sender)
  end

  def leads
    organization.leads
  end

  def referrers
    organization.referrers
  end

  def vcard
    @vcard ||= message.vcard
  end

  def lead_user
    @lead_user ||= begin
      lead_user = User.find_by(phone_number: vcard.phone_number)
      if lead_user.blank?
        lead_user = User.create(vcard.attributes)
      end
      lead_user
    end
  end
end
