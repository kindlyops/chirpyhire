class SmsController < ApplicationController
  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def error_message
    message

    render_sms Sms::Response.error
  end

  private

  def message
    organization.messages.create(sid: params["MessageSid"], media_url: params["MediaUrl0"])
  end

  def sender
    User.find_by(phone_number: params["From"])
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
