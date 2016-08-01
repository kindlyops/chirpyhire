require 'rails_helper'

RSpec.describe AnswerHandlerJob do
  let(:sender) { create(:user) }
  let(:inquiry) { create(:inquiry) }
  let(:fake_message) { FakeMessaging.inbound_message(sender, sender.organization, "test body", format: :text) }
  let(:message_sid) { fake_message.sid }
  let(:message) { create(:message, user: sender, sid: message_sid) }

  describe "#perform" do
    it "handles the message" do
      expect(MessageHandler).to receive(:call).with(sender, message_sid).and_return(message)
      AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
    end

    it "handles the answer" do
      allow(MessageHandler).to receive(:call).with(sender, message_sid).and_return(message)

      expect(AnswerHandler).to receive(:call).with(sender, inquiry, message)
      AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
    end

    context "if the message exists" do
      it "doesn't raise an error" do
        message
        expect {
          AnswerHandlerJob.perform_now(sender, inquiry, message_sid)
        }.not_to raise_error
      end
    end
  end
end
