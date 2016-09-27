require 'rails_helper'

RSpec.describe MessageHandlerJob do
  include ActiveJob::TestHelper
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

      MessageHandlerJob.perform_now(sender, message.sid)
    end

    context 'message does not exist' do
      let(:non_existent_message) { FakeMessaging.non_existent_inbound_message(sender, organization, 'test body', format: :text) }

      it 'enqueues another job' do
        expect {
          MessageHandlerJob.perform_now(sender, non_existent_message.sid)
        }.to have_enqueued_job(MessageHandlerJob)
          .with(
            sender,
            non_existent_message.sid,
            retries: MessageHandlerRetryJob::DEFAULT_RETRIES - 1
          )
      end

      it 'fails when running out of retries' do
        expect {
          perform_enqueued_jobs do
            MessageHandlerJob.perform_now(sender, non_existent_message.sid)
          end
        }.to raise_error(Twilio::REST::RequestError)
      end
    end
  end
end
