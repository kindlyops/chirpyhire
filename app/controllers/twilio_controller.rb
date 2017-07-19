class TwilioController < ActionController::Base
  protect_from_forgery with: :null_session

  def voice
    render xml: twiml.to_xml
  end

  private

  def twiml
    @twiml ||= default_response
  end

  def default_response
    Twilio::TwiML::Response.new do |response|
      response.Pause length: 1
      response.Say sentence_one, voice: 'woman'
      response.Pause length: 1
      response.Say sentence_two, voice: 'woman'
      response.Pause length: 1
      response.Say sentence_three, voice: 'woman'
    end
  end

  def sentence_one
    <<~response
    Hello.
    response
  end

  def sentence_two
    <<~response
    This phone number is set up to only receive text messages.
    response
  end

  def sentence_three
    <<~response
    To reach us, text us back at this number. Have a fantastic day!
    response
  end
end
