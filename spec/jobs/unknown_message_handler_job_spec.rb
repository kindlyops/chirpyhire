require 'rails_helper'

RSpec.describe UnknownMessageHandlerJob do
  extend ::RSpec::Mocks::ExampleMethods

  let(:organization) { create(:organization) }
  let(:sender) { create(:user, organization: organization) }

  let(:message) { FakeMessaging.inbound_message(sender, organization, 'test body', format: :text) }

  let(:new_message) { Message.new(sid: message.sid, body: message.body, direction: message.direction, user: sender) }

  describe '#call' do
    it 'calls the Message Handler' do
      mock_message_handler = double('mock_message_handler')
      allow(mock_message_handler).to receive(:call).and_return(message)

      expect(MessageHandler).to receive(:new)
        .with(sender, message.sid)
        .and_return(mock_message_handler)

      UnknownMessageHandlerJob.perform_now(sender, message.sid)
    end

    context 'message_exists' do
      it 'marks the user as having unread messages' do
        mock_message_handler = double('mock_message_handler')
        allow(mock_message_handler).to receive(:call).and_return(message)

        allow(MessageHandler).to receive(:new)
          .with(sender, message.sid)
          .and_return(mock_message_handler)

        expect {
          UnknownMessageHandlerJob.perform_now(sender, message.sid)
        }.to change { sender.has_unread_messages? }.from(false).to(true)
      end
    end

    context 'message does not exist' do
      let(:non_existent_message) { FakeMessaging.non_existent_inbound_message(sender, organization, 'test body', format: :text) }

      it 'does not mark the user as having unread messages' do
        expect {
          UnknownMessageHandlerJob.perform_now(sender, non_existent_message.sid)
        }.not_to change { sender.has_unread_messages? }
      end

      it 'enqueues another job' do
        expect {
          UnknownMessageHandlerJob.perform_now(sender, non_existent_message.sid)
        }.to have_enqueued_job(UnknownMessageHandlerJob)
          .with(
            sender,
            non_existent_message.sid,
            retries: MessageHandlerRetryJob::DEFAULT_RETRIES - 1
          )
      end
    end
  end
end
