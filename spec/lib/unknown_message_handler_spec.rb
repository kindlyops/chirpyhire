require 'rails_helper'

RSpec.describe UnknownMessageHandler do
  let(:organization) { create(:organization) }
  let(:sender) { create(:user, organization: organization) }

  let(:message) { FakeMessaging.inbound_message(sender, organization, 'test body', format: :text) }
  let(:message_handler) { UnknownMessageHandler.new(sender, message.sid) }

  let(:new_message) { Message.new(sid: message.sid, body: message.body, direction: message.direction, user: sender) }

  describe '#call' do
    it 'calls the Message Handler' do
      expect(MessageHandler).to receive(:call).and_return(new_message)
      message_handler.call
    end

    it 'marks the user as having unread messages' do
      expect do
        message_handler.call
      end.to change { sender.has_unread_messages? }.from(false).to(true)
    end
  end
end
