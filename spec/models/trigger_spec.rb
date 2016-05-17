require 'rails_helper'

RSpec.describe Trigger, type: :model do

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
