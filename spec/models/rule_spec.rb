require 'rails_helper'

RSpec.describe Rule, type: :model do
  describe "#perform" do
    let(:template) { create(:template) }
    let(:rule) { create(:rule, actionable: template.actionable) }
    let(:user) { create(:user) }

    it "performs the action" do
      expect_any_instance_of(Template).to receive(:perform).with(user)

      rule.perform(user)
    end
  end
end
