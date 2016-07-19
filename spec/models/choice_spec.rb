require 'rails_helper'

RSpec.describe Choice, type: :model do
  describe ".extract" do
    let!(:organization) { create(:organization) }
    let!(:persona_feature) { create(:persona_feature, :choice, candidate_persona: organization.create_candidate_persona) }
    let!(:message) { create(:message, body: "A) ") }

    let(:choice_hash) do
      {
        choice_option: "Live-in",
        child_class: "choice"
      }
    end

    it "returns a choice hash" do
      expect(Choice.extract(message, persona_feature)).to eq(choice_hash)
    end
  end
end
