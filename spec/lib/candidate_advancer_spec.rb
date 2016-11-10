require 'rails_helper'

RSpec.describe CandidateAdvancer do
  include RSpec::Rails::Matchers

  let(:user) { create(:user, :with_candidate) }
  let!(:survey) { create(:survey, organization: user.organization) }
  let!(:subscription) { create(:subscription, organization: user.organization) }
  let(:candidate) { user.candidate }

  describe '.call' do
    context 'when the user is unsubscribed' do
      before(:each) do
        user.update(subscribed: false)
      end

      it 'does not create an inquiry of the next candidate feature' do
        expect {
          CandidateAdvancer.call(user)
        }.not_to change { user.inquiries.count }
      end

      it 'does not create a notification' do
        expect {
          CandidateAdvancer.call(user)
        }.not_to change { user.notifications.count }
      end

      it 'does not create a message' do
        expect {
          CandidateAdvancer.call(user)
        }.not_to change { Message.count }
      end

      it 'does not create an AutomatonJob for the screen event' do
        expect {
          CandidateAdvancer.call(user)
        }.not_to have_enqueued_job(AutomatonJob)
      end

      it "does not change the candidate's stage" do
        expect {
          CandidateAdvancer.call(user)
        }.not_to change { candidate.stage }
      end
    end

    context 'when the user is subscribed' do
      before(:each) do
        user.update(subscribed: true)
      end

      context "when the organization's trial is finished" do
        before(:each) do
          subscription.update(state: 'trialing', trial_message_limit: 1)
          create_list(:message, 2, user: user)
        end

        it 'does not create an inquiry of the next candidate feature' do
          expect {
            CandidateAdvancer.call(user)
          }.not_to change { user.inquiries.count }
        end

        it 'does not create a notification' do
          expect {
            CandidateAdvancer.call(user)
          }.not_to change { user.notifications.count }
        end

        it 'does not create a message' do
          expect {
            CandidateAdvancer.call(user)
          }.not_to change { Message.count }
        end

        it 'does not create an AutomatonJob for the screen event' do
          expect {
            CandidateAdvancer.call(user)
          }.not_to have_enqueued_job(AutomatonJob)
        end

        it "does not change the candidate's stage" do
          expect {
            CandidateAdvancer.call(user)
          }.not_to change { candidate.stage }
        end
      end

      context "when the organization's monthly limit is reached" do
        before(:each) do
          subscription.update(state: 'active', quantity: 1)
          Plan.messages_per_quantity = 1
          create(:message, user: user)
        end

        it 'does not create an inquiry of the next candidate feature' do
          expect {
            CandidateAdvancer.call(user)
          }.not_to change { user.inquiries.count }
        end

        it 'does not create a notification' do
          expect {
            CandidateAdvancer.call(user)
          }.not_to change { user.notifications.count }
        end

        it 'does not create a message' do
          expect {
            CandidateAdvancer.call(user)
          }.not_to change { Message.count }
        end

        it 'does not create an AutomatonJob for the screen event' do
          expect {
            CandidateAdvancer.call(user)
          }.not_to have_enqueued_job(AutomatonJob)
        end

        it "does not change the candidate's stage" do
          expect {
            CandidateAdvancer.call(user)
          }.not_to change { candidate.stage }
        end
      end

      context 'initial question' do
        let!(:question) { create(:question, survey: survey) }
        let!(:welcome) { survey.welcome }
        let(:organization) { user.organization }

        let(:formatted_text) { question.becomes(question.type.constantize).formatted_text }

        let(:subscription_notice) do
          "If you ever wish to stop receiving text messages from #{organization.name} just reply STOP."
        end

        let(:initial_message) do
          "#{welcome.body}\n\n#{subscription_notice}\n\n#{formatted_text}"
        end

        it 'appends the welcome, unsubscribed notification, and the question together' do
          CandidateAdvancer.call(user)
          expect(user.messages.last.body).to eq(initial_message)
        end
      end

      context 'with an undetermined or stale profile feature' do
        before(:each) do
          create(:question, survey: survey)
        end

        it 'creates an inquiry of the next candidate feature' do
          expect {
            CandidateAdvancer.call(user)
          }.to change { user.inquiries.count }.by(1)
        end

        it 'creates a message' do
          expect {
            CandidateAdvancer.call(user)
          }.to change { Message.count }.by(1)
        end

        context 'and the last answer was unacceptable' do
          let!(:prior_question) { create(:document_question, survey: survey) }
          let!(:prior_inquiry) { create(:inquiry, question: prior_question, message: create(:message, user: user)) }
          let(:question) { create(:document_question, survey: survey) }
          let(:inquiry) { create(:inquiry, question: question) }
          let(:message) { create(:message, :with_image, user: user) }
          let!(:answer) { create(:answer, inquiry: inquiry, message: message) }

          before do
            allow_any_instance_of(Question).to receive(:rejects?).and_return(true)
          end

          context 'with a template for the survey' do
            it 'does not create an inquiry of the next candidate feature' do
              expect {
                CandidateAdvancer.call(user)
              }.not_to change { user.inquiries.count }
            end

            it 'creates a notification' do
              expect {
                CandidateAdvancer.call(user)
              }.to change { user.notifications.count }.by(1)
            end

            it 'creates a message' do
              expect {
                CandidateAdvancer.call(user)
              }.to change { Message.count }.by(1)
            end

            it "changes the candidate's stage to Bad Fit" do
              expect {
                CandidateAdvancer.call(user)
              }.to change { candidate.stage }.from(user.organization.potential_stage).to(user.organization.bad_fit_stage)
            end
          end
        end
      end

      context 'with all profile features present' do
        let!(:prior_question) { create(:document_question, survey: survey) }
        let!(:prior_inquiry) { create(:inquiry, question: prior_question, message: create(:message, user: user)) }
        let!(:choice_question) { create(:choice_question, survey: survey) }
        let!(:inquiry) { create(:inquiry, question: choice_question, message: create(:message, user: user)) }
        let!(:message) { create(:message, body: choice_question.choice_question_options.first.letter, user: user) }
        let!(:answer) { create(:answer, inquiry: inquiry, message: message) }

        it 'creates an AutomatonJob for the screen event' do
          expect {
            CandidateAdvancer.call(user)
          }.to have_enqueued_job(AutomatonJob).with(user, 'screen')
        end

        it "changes the candidate's stage to Qualified" do
          expect {
            CandidateAdvancer.call(user)
          }.to change { candidate.stage }.from(user.organization.potential_stage).to(user.organization.qualified_stage)
        end
      end
    end
  end
end
