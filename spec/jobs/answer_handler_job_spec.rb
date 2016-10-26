require 'rails_helper'

RSpec.describe AnswerHandlerJob do
  include ActiveJob::TestHelper
  extend ::RSpec::Mocks::ExampleMethods

  let(:sender) { create(:user) }
  let!(:question) { create(:question, :choice) }
  let!(:option) { question.becomes(ChoiceQuestion).choice_question_options.first.letter }
  let(:inquiry) { create(:inquiry) }
  let(:fake_message) { FakeMessaging.inbound_message(sender, sender.organization, 'test body', format: :text) }
  let(:message_sid) { fake_message.sid }
  let(:message) { create(:message, user: sender, sid: message_sid, body: option) }

  describe '#perform' do
    it 'handles the message' do
      mock_message_handler = double('mock_message_handler')
      expect(mock_message_handler).to receive(:call).and_return(message)
      expect(MessageHandler).to receive(:new).with(sender, message.sid).and_return(mock_message_handler)
      AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
    end

    it 'handles the answer' do
      mock_message_handler = double('mock_message_handler')
      allow(mock_message_handler).to receive(:call).and_return(message)
      allow(MessageHandler).to receive(:new).with(sender, message.sid).and_return(mock_message_handler)

      expect {
        AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
      }.not_to raise_error
    end

    context 'if the message exists' do
      it "doesn't raise an error" do
        expect {
          AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
        }.not_to raise_error
      end
    end

    context 'if the message does not exist' do
      let(:fake_message) { FakeMessaging.non_existent_inbound_message(sender, sender.organization, 'test body', format: :text) }

      it 'enqueues another answer handler job' do
        expect {
          AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
        }.to have_enqueued_job(AnswerHandlerJob).with(sender, inquiry, message_sid, retries: MessageHandlerRetryJob::DEFAULT_RETRIES - 1)
      end

      it "doesn't call into the answer handler" do
        expect {
          AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
        }.not_to have_enqueued_job(AutomatonJob)
      end

      it 'fails when running out of retries' do
        expect {
          perform_enqueued_jobs do
            AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
          end
        }.to raise_error(Twilio::REST::RequestError)
      end
    end
  end
end
