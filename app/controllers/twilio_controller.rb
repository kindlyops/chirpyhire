class TwilioController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :set_header

  def voice
    if phone_number.forwarding_phone_number.present?
      render xml: forward_twiml.to_xml
    else
      render xml: default_twiml.to_xml
    end
  end

  private

  def phone_number
    @phone_number ||= PhoneNumber.find_by(phone_number: params['To'])
  end

  def forward_twiml
    Twilio::TwiML::Response.new do |response|
      response.Dial phone_number.forwarding_phone_number
    end
  end

  def default_twiml
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

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end

  delegate :organization, to: :phone_number
end
