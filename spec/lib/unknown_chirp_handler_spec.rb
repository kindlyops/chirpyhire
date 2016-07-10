require 'rails_helper'

RSpec.describe UnknownChirpHandler do
  let(:organization) { create(:organization) }
  let(:sender) { create(:user, organization: organization) }

  let(:message) { FakeMessaging.inbound_message(sender, organization, "test body", format: :text) }
  let(:chirp_handler) { UnknownChirpHandler.new(sender, message.sid) }

  let(:new_message) { Message.new(sid: message.sid, body: message.body, direction: message.direction, user: sender) }

  describe "#call" do
    it "calls the Message Handler" do
      expect(MessageHandler).to receive(:call).and_return(new_message)
      chirp_handler.call
    end
  end
end
