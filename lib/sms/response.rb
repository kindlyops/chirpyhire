class Sms::Response

  def initialize
    yield response if block_given?
  end

  def text
    response.text
  end

  private

  def response
    Twilio::TwiML::Response.new
  end

end
