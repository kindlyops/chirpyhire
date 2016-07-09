require 'rails_helper'

RSpec.describe ActivitiesController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:message) { create(:message, user: user) }
  let(:account) { user.account }
  let(:organization) { user.organization }

  before(:each) do
    sign_in(account)
  end

  describe "#update" do
    let(:candidate) { create(:candidate, user: user) }
    let!(:activity) { candidate.create_activity :screen, outstanding: true, owner: user }

    context "with valid rule params" do
      let(:activity_params) do
        { id: activity.id,
          activity: {
          outstanding: false
        } }
      end

      it "updates the activity" do
        expect {
          put :update, xhr: true, params: activity_params
        }.to change{activity.reload.outstanding?}.from(true).to(false)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { id: activity.id,
          activity: {
            message_id: 1
          }
        }
      end

      it "does not create a activity" do
        expect {
          put :update, xhr: true, params: invalid_params
        }.not_to change{Activity.count}
      end
    end
  end
end
