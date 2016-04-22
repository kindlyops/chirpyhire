class Sms::Client
  def initialize(context)
    @account_sid = context.twilio_account_sid
    @auth_token = context.twilio_auth_token
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def send_message(message)
    client.account.messages.create(message)
  end

  attr_accessor :client

  private

  attr_reader :account_sid, :auth_token
end
