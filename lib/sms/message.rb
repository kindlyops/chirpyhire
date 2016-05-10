module Sms
  class Message
    def initialize(message)
      @message = message
    end

    private

    attr_reader :message

    def method_missing(method, *args, &block)
      message.send(method, *args, &block)
    end
  end
end
