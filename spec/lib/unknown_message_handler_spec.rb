require 'rails_helper'
require 'mock_helper'

RSpec.describe UnknownMessageHandler do
  let(:organization) { create(:organization) }
  let(:sender) { create(:user, organization: organization) }

  let(:message) { FakeMessaging.inbound_message(sender, organization, 'test body', format: :text) }
  let(:unknown_message_handler) { UnknownMessageHandler.new(sender, message.sid) }

  let(:new_message) { Message.new(sid: message.sid, body: message.body, direction: message.direction, user: sender) }

  describe "#call" do
    it "calls the Message Handler" do
      Mock.message_handler(sender, message)      
      unknown_message_handler.call
    end

    it 'marks the user as having unread messages' do
      expect{
        unknown_message_handler.call
      }.to change{sender.has_unread_messages?}.from(false).to(true)
    end
  end
end
