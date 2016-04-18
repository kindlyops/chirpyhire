class Sms::Response
  def initialize(&block)
    @response = Twilio::TwiML::Response.new(&block)
  end

  def text
    response.text
  end

  private

  attr_reader :response
end
