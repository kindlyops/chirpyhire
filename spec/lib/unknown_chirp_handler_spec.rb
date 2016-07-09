require 'rails_helper'

RSpec.describe UnknownChirpHandler do
  let(:organization) { create(:organization) }
  let(:sender) { create(:user, organization: organization) }

  let(:message) { FakeMessaging.inbound_message(sender, organization, "test body", format: :text) }
  let(:chirp_handler) { UnknownChirpHandler.new(sender, message.sid) }

  let(:new_message) { Message.new(sid: message.sid, body: message.body, direction: message.direction, user: sender) }

  describe "#call" do
    it "creates a chirp" do
      expect {
        chirp_handler.call
      }.to change{sender.chirps.count}.by(1)
    end

    it "calls the Message Handler" do
      expect(MessageHandler).to receive(:call).and_return(new_message)
      chirp_handler.call
    end

    context "without an outstanding activity" do
      it "creates an outstanding activity for the user" do
        expect {
          chirp_handler.call
        }.to change{organization.outstanding_activities.count}.by(1)
      end
    end
  end
end
