class SmsController < ActionController::Base
  after_filter :set_header

  protect_from_forgery with: :null_session

  def error_message
    render_sms Messaging::Response.error
  end

  private

  def message
    @message ||= sender.messages.create(sid: params["MessageSid"], properties: params)
  end

  def vcard
    @vcard ||= Vcard.new(message: message)
  end

  def sender
    @sender ||= UserFinder.new(attributes: {phone_number: params["From"]}, organization: organization).call
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
