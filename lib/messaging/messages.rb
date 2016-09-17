# frozen_string_literal: true
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
      messages.send(method, *args, &block)
    end
  end
end
