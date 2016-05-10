require 'rails_helper'

RSpec.describe Action, type: :model do
  let(:action) { create(:action) }
  let(:actionable) { action.actionable }
  let(:template) { actionable.template }
  let(:candidate) { create(:candidate) }

  describe "#perform" do
    before(:each) do
      allow(actionable).to receive(:perform).and_return(create(:message))
    end

    context "actionable question" do
      it "creates an inquiry" do
        expect {
          action.perform(candidate)
        }.to change{actionable.inquiries.count}.by(1)
      end
    end

    context "actionable notice" do
      let(:action) { create(:action, :with_notice) }

      it "creates a notification" do
        expect {
          action.perform(candidate)
        }.to change{actionable.notifications.count}.by(1)
      end
    end
  end

  describe "description" do
    it "is the name of the template" do
      expect(action.description).to eq(template.name)
    end
  end
end
