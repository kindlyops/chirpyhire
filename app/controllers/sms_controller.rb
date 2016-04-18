class SmsController < ApplicationController
  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def text
    render_sms sms
  end

  private

  def sms
    Sms::Response.new do |r|
      r.Message "Sorry I didn't understand that. Have a great day!"
    end
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
