require 'rails_helper'

RSpec.describe Sms::AnswersController, type: :controller do
  let(:organization) { create(:organization, phone_number: Faker::PhoneNumber.cell_phone) }
  let(:user) { create(:user, organization: organization) }
  let(:message) { create(:message, user: user) }
  let(:survey) { create(:survey, organization: organization) }
  let(:inbound_message) { FakeMessaging.inbound_message(user, user.organization) }

  describe '#create' do
    let(:params) do
      {
        'To' => inbound_message.to,
        'From' => inbound_message.from,
        'Body' => inbound_message.body,
        'MessageSid' => inbound_message.sid,
        'MediaUrl0' => inbound_message.media_urls[0]
      }
    end

    it 'is ok' do
      post :create, params: params
      expect(response).to be_ok
    end

    let(:question) { create(:question, survey: survey) }
    let(:candidate_feature) { create(:candidate_feature, label: question.label) }

    context 'with an outstanding inquiry' do
      let(:inquiry) { create(:inquiry, message: message, question: question) }

      it 'creates a AnswerHandlerJob' do
        expect do
          post :create, params: params
        end.to have_enqueued_job(AnswerHandlerJob).with(user, inquiry, inbound_message.sid)
      end
    end

    context 'without an outstanding inquiry' do
      let(:inquiry) { nil }

      it 'does not create an AnswerHandlerJob' do
        expect do
          post :create, params: params
        end.not_to have_enqueued_job(AnswerHandlerJob)
      end

      it 'creates an UnknownMessageHandlerJob' do
        expect do
          post :create, params: params
        end.to have_enqueued_job(UnknownMessageHandlerJob).with(user, inbound_message.sid)
      end
    end
  end
end
