require 'rails_helper'

RSpec.describe BackPopulate::CandidateStagePopulator do
  let(:organization) { create(:organization) }
  let(:hired_candidate) { create(:candidate, status: 'Hired', organization: organization) }
  let(:potential_candidate) { create(:candidate, status: 'Potential', organization: organization) }
  let(:qualified_candidate) { create(:candidate, status: 'Qualified', organization: organization) }
  let(:bad_fit_candidate) { create(:candidate, status: 'Bad Fit', organization: organization) }

  describe '#populate' do
    around(:each) do |example|
      StageDefaults.populate(organization)
      organization.save!
      example.run
    end

    context 'candidate does not have a stage' do
      it 'populates it properly for hired' do
        expect {
          BackPopulate::CandidateStagePopulator.populate(hired_candidate)
        }.to change { hired_candidate.stage_id }.from(nil).to(organization.hired_stage.id)
      end
      it 'populates it properly for potential' do
        expect {
          BackPopulate::CandidateStagePopulator.populate(potential_candidate)
        }.to change { potential_candidate.stage_id }.from(nil).to(organization.potential_stage.id)
      end
      it 'populates it properly for qualified' do
        expect {
          BackPopulate::CandidateStagePopulator.populate(qualified_candidate)
        }.to change { qualified_candidate.stage_id }.from(nil).to(organization.qualified_stage.id)
      end
      it 'populates it properly for bad_fit' do
        expect {
          BackPopulate::CandidateStagePopulator.populate(bad_fit_candidate)
        }.to change { bad_fit_candidate.stage_id }.from(nil).to(organization.bad_fit_stage.id)
      end
    end
  end
end
