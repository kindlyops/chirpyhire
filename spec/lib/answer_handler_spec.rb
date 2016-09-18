require 'rails_helper'

RSpec.describe AnswerHandler do
  include RSpec::Rails::Matchers

  let(:candidate) { create(:candidate) }
  let!(:user) { candidate.user }
  let!(:message) { create(:message, user: user) }
  let(:survey) { create(:survey, organization: user.organization) }
  let(:question) { create(:question, :document, survey: survey) }

  let!(:inquiry) { create(:inquiry, message: message, question: question) }
  let!(:message) { create(:message, :with_image, user: user) }

  describe '.call' do
    context 'with an answer format that matches the feature format' do
      it 'creates an answer' do
        expect do
          AnswerHandler.call(user, inquiry, message)
        end.to change { Answer.count }.by(1)
      end

      it 'creates a AutomatonJob' do
        expect do
          AnswerHandler.call(user, inquiry, message)
        end.to have_enqueued_job(AutomatonJob).with(user, 'answer')
      end

      context 'when the inquiry has already been answered' do
        let!(:inquiry) { create(:inquiry, :with_answer, message: message, question: question) }

        it 'does not create an answer' do
          expect do
            AnswerHandler.call(user, inquiry, message)
          end.not_to change { Answer.count }
        end

        it 'does not create an AutomatonJob' do
          expect do
            AnswerHandler.call(user, inquiry, message)
          end.not_to have_enqueued_job(AutomatonJob)
        end
      end
    end

    context "with an answer format that doesn't matches the feature format" do
      context 'image mismatch', vcr: { cassette_name: 'AnswerHandlerFormatMismatch' } do
        let(:body) { 'a test body' }
        let!(:message) { create(:message, user: user, body: body) }

        it 'does not create an answer' do
          expect do
            AnswerHandler.call(user, inquiry, message)
          end.not_to change { Answer.count }
        end
      end
    end
  end
end
