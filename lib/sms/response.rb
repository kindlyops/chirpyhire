class Sms::Response
  def self.error
    new do |r|
      r.Message "Sorry I didn't understand that. Have a great day!"
    end
  end

  def initialize(&block)
    @response = Twilio::TwiML::Response.new(&block)
  end

  def text
    response.text
  end

  private

  attr_reader :response
end
