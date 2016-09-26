require 'rails_helper'

RSpec.describe SurveyAdvancer do
  let(:organization) { create(:organization) }
  let(:advancer) { SurveyAdvancer }

  describe '#call' do
    context 'with a Potential candidate' do
      let(:user) { create(:user, organization: organization) }
      let!(:candidate) { create(:candidate, stage: organization.potential_stage, user: user) }

      let!(:survey) { create(:survey, organization: organization) }
      let(:question) { create(:question, survey: survey) }

      context 'with no outstanding inquiry' do
        it 'enqueues a CandidateAdvancerJob' do
          expect {
            advancer.call(organization)
          }.to have_enqueued_job(CandidateAdvancerJob).with(user)
        end

        context 'multiple candidates' do
          let(:second_user) { create(:user, organization: organization) }
          let!(:second_candidate) { create(:candidate, stage: organization.potential_stage, user: second_user) }

          it 'enqueues a CandidateAdvancerJob for each candidate' do
            expect {
              advancer.call(organization)
            }.to have_enqueued_job(CandidateAdvancerJob).exactly(2).times
          end
        end
      end

      context 'with outstanding inquiry' do
        let(:message) { create(:message, user: user) }
        let!(:inquiry) { create(:inquiry, question: question, message: message) }

        it 'does not enqueue a CandidateAdvancerJob' do
          expect {
            advancer.call(organization)
          }.not_to have_enqueued_job(CandidateAdvancerJob)
        end
      end
    end

    context 'with a non Potential candidate' do
      let(:user) { create(:user, organization: organization) }
      let(:candidate) { create(:candidate, organization.bad_fit_stage, user: user) }

      it 'does not enqueue a CandidateAdvancerJob' do
        expect {
          advancer.call(organization)
        }.not_to have_enqueued_job(CandidateAdvancerJob)
      end
    end
  end
end
