class TwilioController < ApplicationController
  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def text
    response = Twilio::TwiML::Response.new do |r|
      r.Message "Sorry I didn't understand that. Have a great day!"
    end

    render_twiml response
  end

  private

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_twiml(response)
    render text: response.text
  end
end
