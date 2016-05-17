module Messaging
  class Client
    cattr_accessor :client
    self.client = Twilio::REST::Client

    def initialize(context)
      @account_sid = context.twilio_account_sid
      @auth_token = context.twilio_auth_token
      @client = self.class.client.new(account_sid, auth_token)
    end

    def messages
      Messaging::Messages.new(client.account.messages)
    end

    def send_message(message)
      Messaging::Message.new(client.account.messages.create(message))
    end

    private

    attr_reader :account_sid, :auth_token, :client
  end
end
