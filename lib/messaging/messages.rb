module Messaging
  class Messages
    def initialize(messages)
      @messages = messages
    end

    def get(sid)
      Messaging::Message.new(messages.get(sid))
    end

    private

    attr_reader :messages

    def method_missing(method, *args, &block)
      messages.send(method, *args, &block) || super
    end

    def respond_to_missing?(method_name, include_private = false)
      super
    end
  end
end
