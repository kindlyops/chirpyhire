require 'rails_helper'

RSpec.describe ActionDecorator do
  let(:model) { create(:action) }
  let(:action) { ActionDecorator.new(model) }

  let(:actionable) { model.actionable }
  let(:template) { actionable.template }

  describe "description" do
    it "is the name of the template" do
      expect(action.description).to eq(template.name)
    end
  end
end
