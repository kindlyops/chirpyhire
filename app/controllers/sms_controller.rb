class SmsController < ApplicationController
  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def error_message
    message

    render_sms Sms::Response.error
  end

  private

  def message
    organization.messages.find_or_create_by(sid: params["MessageSid"], media_url: params["MediaUrl0"])
  end

  def vcard
    message.vcard
  end

  def sender
    UserFinder.new(attributes: { phone_number: params["From"] }).call
  end

  def organization
    Organization.joins(:phone).find_by(phones: { number: params["To"] })
  end

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_sms(sms)
    render text: sms.text
  end
end
