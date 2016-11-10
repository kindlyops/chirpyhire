require 'rails_helper'

RSpec.describe MessageHandler do
  include RSpec::Rails::Matchers

  let(:organization) { create(:organization) }
  let(:sender) { create(:user, organization: organization) }
  let(:fake_message) { FakeMessaging.inbound_message(sender, organization, 'test body', format: :text) }

  let(:message_handler) { MessageHandler.new(sender, fake_message.sid) }

  let(:message) { message_handler.call }
  describe '#call' do
    include ActiveJob::TestHelper
    context 'where message exists' do
      it 'creates the message' do
        expect {
          message
        }.to change { Message.count }.by(1)
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
end
