module Messaging
  class Response

    def initialize(&block)
      @response = Twilio::TwiML::Response.new(&block)
    end

    def text
      response.text
    end

    private

    attr_reader :response

    def error
      "Sorry I didn't understand that. Have a great day!"
    end
  end
end
