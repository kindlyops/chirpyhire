require 'rails_helper'

RSpec.describe MessageHandler do
  include RSpec::Rails::Matchers

  let(:organization) { create(:organization) }
  let(:sender) { create(:user, organization: organization) }
  let(:fake_message) { FakeMessaging.inbound_message(sender, organization, 'test body', format: :text) }

  let(:message_handler) { MessageHandler.new(sender, fake_message.sid) }

  let(:message) { message_handler.call }
  describe '#call' do
    it 'creates the message' do
      expect {
        message
      }.to change { Message.count }.by(1)
    end

    context 'with prior messages' do
      let!(:first_message) { create(:message, user: sender, created_at: Date.yesterday) }
      let!(:most_recent_message) { create(:message, user: sender) }

      it 'sets the new message as the child on the most recent message' do
        message
        expect(sender.messages.by_recency.second.child).to eq(message)
      end
    end

    context 'with media' do
      let(:fake_message) { FakeMessaging.inbound_message(sender, organization) }

      it 'creates the media instances' do
        expect {
          message
        }.to change { MediaInstance.count }.by(1)
        expect(message.media_instances.length).to eq(1)
      end
    end
  end
end
