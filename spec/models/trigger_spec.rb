require 'rails_helper'

RSpec.describe Trigger, type: :model do

  describe "#description" do
    context "with observable" do
      let(:trigger) { create(:trigger, :with_observable) }
      let(:template) { trigger.observable.template }

      it "is the observable's template name" do
        expect(trigger.description).to eq(template.name)
      end
    end

    context "with only observable type" do
      let(:trigger) { create(:trigger, observable_type: "Candidate") }

      it "is the type" do
        expect(trigger.description).to eq(trigger.observable_type)
      end
    end
  end

  describe "#fire" do
    let(:trigger) { create(:trigger) }
    let(:user) { create(:user) }

    context "with actions" do
      let!(:action) { create(:action, trigger: trigger) }

      it "performs the action" do
        expect_any_instance_of(Action).to receive(:perform).with(user)
        trigger.fire(user)
      end
    end
  end
end
