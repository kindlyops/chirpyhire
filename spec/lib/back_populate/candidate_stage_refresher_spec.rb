require 'rails_helper'

RSpec.describe BackPopulate::CandidateStageRefresher do
  Candidate.skip_callback(:create, :before, :ensure_candidate_has_stage)
  let(:organization) { create(:organization) }
  let(:hired_candidate) { create(:candidate, status: "Hired", organization: organization) }
  let(:potential_candidate) { create(:candidate, status: "Potential", organization: organization) }
  let(:qualified_candidate) { create(:candidate, status: "Qualified", organization: organization) }
  let(:bad_fit_candidate) { create(:candidate, status: "Bad Fit", organization: organization) }
  let(:candidate_with_stage) { create(:candidate, organization: organization, stage: organization.potential_stage) }

  describe "#refresh" do
    context "candidate does not have a stage" do
      it "populates it properly for hired" do
        expect {
          BackPopulate::CandidateStageRefresher.refresh(hired_candidate)
        }.to change{ hired_candidate.stage_id }.from(nil).to(organization.hired_stage.id)
      end
      it "populates it properly for potential" do
        expect {
          BackPopulate::CandidateStageRefresher.refresh(potential_candidate)
        }.to change{ potential_candidate.stage_id }.from(nil).to(organization.potential_stage.id)
      end
      it "populates it properly for qualified" do
        expect {
          BackPopulate::CandidateStageRefresher.refresh(qualified_candidate)
        }.to change{ qualified_candidate.stage_id }.from(nil).to(organization.qualified_stage.id)
      end
      it "populates it properly for bad_fit" do
        expect {
          BackPopulate::CandidateStageRefresher.refresh(bad_fit_candidate)
        }.to change{ bad_fit_candidate.stage_id }.from(nil).to(organization.bad_fit_stage.id)
      end
    end
    context "candidate already has a stage" do 
      it "does nothing" do
        expect {
          BackPopulate::CandidateStageRefresher.refresh(candidate_with_stage)
        }.not_to change{ candidate_with_stage.stage_id }
      end
    end
  end
end
