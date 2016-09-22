require 'rails_helper'
require 'mock_helper'

RSpec.describe AnswerHandlerJob do
  let(:sender) { create(:user) }
  let(:inquiry) { create(:inquiry) }
  let(:fake_message) { FakeMessaging.inbound_message(sender, sender.organization, 'test body', format: :text) }
  let(:message_sid) { fake_message.sid }
  let(:message) { create(:message, user: sender, sid: message_sid) }

  describe '#perform' do
    it 'handles the message' do
      mock_message_handler = double('mock_message_handler')
      expect(mock_message_handler).to receive(:call).and_return(message)
      expect(MessageHandler).to receive(:new).with(sender, message.sid).and_return(mock_message_handler)
      AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
    end

    it 'handles the answer' do
      Mock.message_handler(sender, message)
      expect(AnswerHandler).to receive(:call).with(sender, inquiry, message)
      AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
    end

    context 'if the message exists' do
      it "doesn't raise an error" do
        message
        expect {
          AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
        }.not_to raise_error
      end
    end
  end
end
