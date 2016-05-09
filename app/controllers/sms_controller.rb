class SmsController < ActionController::Base
  after_filter :set_header

  protect_from_forgery with: :null_session

  def error_message
    message

    render_sms Sms::Response.error
  end

  private

  def message
    @message ||= MessageFinder.call(sender, params)
  end

  def vcard
    @vcard ||= Vcard.new(message: message)
  end

  def sender
    @sender ||= organization.users.find_or_create_by(phone_number: params["From"])
  end

  def organization
    @organization ||= Organization.for(phone: params["To"])
  end

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_sms(sms)
    render text: sms.text
  end
end
