require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  describe "#unsubscribed?" do
    context "with a subscription to the organization" do
      it "is false" do
        user.update(subscribed: true)
        expect(user.unsubscribed?).to eq(false)
      end
    end

    context "without a subscription to the organization" do
      it "is true" do
        user.update(subscribed: false)
        expect(user.unsubscribed?).to eq(true)
      end
    end
  end
end
