class TwilioController < ActionController::Base
  protect_from_forgery with: :null_session

  def voice
    render xml: twiml.to_xml
  end

  private

  def twiml
    @twiml ||= begin
      Twilio::TwiML::Response.new do |response|
        response.Say "Hello World!"
      end
    end
  end
end
