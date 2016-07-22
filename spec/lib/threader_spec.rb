require 'rails_helper'

RSpec.describe Threader do

  describe ".thread" do
    let(:user) { create(:user) }
    let(:messages) { user.messages.by_recency }

    context "with a user with multiple messages" do
      let!(:oldest) { create(:message, user: user, created_at: 4.days.ago) }
      let!(:second_oldest) { create(:message, user: user, created_at: 3.days.ago) }
      let!(:third_oldest) { create(:message, user: user, created_at: 2.days.ago) }
      let!(:fourth_oldest) { create(:message, user: user, created_at: 1.days.ago) }

      it "threads appropriately" do
        Threader.thread

        expect(oldest.reload.parent_id).to eq(nil)
        expect(second_oldest.reload.parent_id).to eq(oldest.id)
        expect(third_oldest.reload.parent_id).to eq(second_oldest.id)
        expect(fourth_oldest.reload.parent_id).to eq(third_oldest.id)
      end
    end
  end
end
