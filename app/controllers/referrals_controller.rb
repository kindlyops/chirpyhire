class ReferralsController < SmsController
  before_action :require_sender

  def create
    render_sms referral.sms_response
  end

  private

  def referral
    @referral ||= referral_creator.call
  end

  def referral_creator
    ReferralCreator.new(message: message,
                        organization: organization,
                        sender: sender)
  end

  def require_sender
    error_message unless sender.present?
  end
end
