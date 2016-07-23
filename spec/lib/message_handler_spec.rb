require 'rails_helper'

RSpec.describe MessageHandler do
  include RSpec::Rails::Matchers

  let(:organization) { create(:organization) }
  let(:sender) { create(:user, organization: organization) }
  let(:fake_message) { FakeMessaging.inbound_message(sender, organization, "test body", format: :text) }
  let(:external_message) { organization.get_message(fake_message.sid) }
  let(:message_handler) { MessageHandler.new(sender, external_message) }

  let(:message) { message_handler.call }
  describe "#call" do
    it "initializes the message" do
      expect(message).to be_a_new(Message)
    end

    context "with prior messages" do
      let!(:first_message) { create(:message, user: sender, created_at: Date.yesterday) }
      let!(:most_recent_message) { create(:message, user: sender) }

      it "sets the most recent message as the parent" do
        message.save
        expect(sender.messages.by_recency.first.parent).to eq(most_recent_message)
      end
    end

    context "with media" do
      let(:fake_message) { FakeMessaging.inbound_message(sender, organization) }

      it "initializes the media instances" do
        message.media_instances.each do |instance|
          expect(instance).to be_a_new(MediaInstance)
        end
        expect(message.media_instances.length).to eq(1)
      end
    end
  end
end
