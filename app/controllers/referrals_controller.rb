class ReferralsController < TwilioController

  def create
    render_twiml response
  end

  private

  def response
    return super unless referral.valid?
    referral.response
  end

  def referral
    @referral ||= referrer_creator.call
  end

  def referrer_creator
    ReferralCreator.new(vcard: vcard,
                        organization: organization,
                        sender: sender)
  end

  def vcard
    Vcard.new(url: params["MediaUrl0"])
  end
end
