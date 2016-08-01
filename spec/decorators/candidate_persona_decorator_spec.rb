require 'rails_helper'

RSpec.describe CandidatePersonaDecorator do
  let(:model) { create(:candidate_persona) }
  let(:candidate_persona) { CandidatePersonaDecorator.new(model) }

  describe "#persona_features" do
    let!(:deleted_feature) { create(:persona_feature, candidate_persona: candidate_persona, deleted_at: Time.current, priority: 1) }
    let!(:current_feature) { create(:persona_feature, candidate_persona: candidate_persona, deleted_at: nil, priority: 2) }

    context "with deleted features" do
      context "that have a higher priority than existing features" do

        it "returns the deleted features last" do
          expect(candidate_persona.persona_features).to eq([current_feature, deleted_feature])
        end
      end
    end
  end
end
