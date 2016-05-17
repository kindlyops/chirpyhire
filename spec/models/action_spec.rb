require 'rails_helper'

RSpec.describe Action, type: :model do
  let(:action) { create(:action) }
  let(:actionable) { action.actionable }
  let(:template) { actionable.template }

  describe "description" do
    it "is the name of the template" do
      expect(action.description).to eq(template.name)
    end
  end
end
