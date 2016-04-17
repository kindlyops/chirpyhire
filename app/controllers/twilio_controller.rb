class TwilioController < ApplicationController
  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def text
    render_twiml response
  end

  private

  def response
    Twilio::TwiML::Response.new do |r|
      r.Message "Sorry I didn't understand that. Have a great day!"
    end
  end

  def sender
    User.find_by(phone_number: params[:from])
  end

  def organization
    Organization.find_by(phone: { number: params[:to] })
  end

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_twiml(response)
    render text: response.text
  end
end
