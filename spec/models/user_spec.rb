require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "#last_answer" do
    context "with multiple answers" do
      let(:first_message) { create(:message, :with_image, user: user) }
      let!(:first_answer) { create(:answer, message: first_message, created_at: 7.days.ago) }
      let(:second_message) { create(:message, :with_image, user: user) }
      let!(:second_answer) { create(:answer, message: second_message) }

      it "is the most recently created answer" do
        expect(user.last_answer).to eq(second_answer)
      end
    end
  end

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
