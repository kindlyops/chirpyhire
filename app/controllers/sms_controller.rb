class SmsController < ActionController::Base
  after_filter :set_header

  protect_from_forgery with: :null_session

  def error_message
    message

    render_sms Sms::Response.error
  end

  private

  def message
    @message ||= sender.messages.find_or_create_by(sid: params["MessageSid"], media_url: params["MediaUrl0"])
  end

  def vcard
    @vcard ||= message.vcard
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
