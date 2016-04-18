class ReferralsController < SmsController

  def create
    render_sms sms
  end

  private

  def sms
    return super unless referral.valid?
    referral.sms_response
  end

  def referral
    @referral ||= referrer_creator.call
  end

  def referrer_creator
    ReferralCreator.new(message: message,
                        organization: organization,
                        sender: sender)
  end

  def message
    Sms::Message.new(sid: params["MessageSid"], url: params["MediaUrl0"])
  end
end
