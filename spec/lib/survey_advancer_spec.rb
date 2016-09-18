require 'rails_helper'

RSpec.describe SurveyAdvancer do
  let(:organization) { create(:organization) }
  let(:advancer) { described_class }

  describe '#call' do
    context 'with a Potential candidate' do
      let(:user) { create(:user, organization: organization) }
      let!(:candidate) { create(:candidate, status: 'Potential', user: user) }

      let!(:survey) { create(:survey, organization: organization) }
      let(:question) { create(:question, survey: survey) }

      context 'with no outstanding inquiry' do
        it 'enqueues a CandidateAdvancerJob' do
          expect do
            advancer.call(organization)
          end.to have_enqueued_job(CandidateAdvancerJob).with(user)
        end

        context 'multiple candidates' do
          let(:second_user) { create(:user, organization: organization) }
          let!(:second_candidate) { create(:candidate, status: 'Potential', user: second_user) }

          it 'enqueues a CandidateAdvancerJob for each candidate' do
            expect do
              advancer.call(organization)
            end.to have_enqueued_job(CandidateAdvancerJob).exactly(2).times
          end
        end
      end

      context 'with outstanding inquiry' do
        let(:message) { create(:message, user: user) }
        let!(:inquiry) { create(:inquiry, question: question, message: message) }

        it 'does not enqueue a CandidateAdvancerJob' do
          expect do
            advancer.call(organization)
          end.not_to have_enqueued_job(CandidateAdvancerJob)
        end
      end
    end

    context 'with a non Potential candidate' do
      let(:user) { create(:user, organization: organization) }
      let(:candidate) { create(:candidate, status: 'Bad Fit', user: user) }

      it 'does not enqueue a CandidateAdvancerJob' do
        expect do
          advancer.call(organization)
        end.not_to have_enqueued_job(CandidateAdvancerJob)
      end
    end
  end
end
