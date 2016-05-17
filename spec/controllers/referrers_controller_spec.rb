require 'rails_helper'

RSpec.describe ReferrersController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:account) { user.account }
  let(:organization) { user.organization }

  before(:each) do
    sign_in(account)
  end

  describe "#index" do
    it "is OK" do
      get :index
      expect(response).to be_ok
    end

    context "with referrers" do
      let(:users) { create_list(:user, 3, organization: organization) }
      let!(:referrers) do
        3.times.map do |i|
          create(:referrer, user: users[i-1])
        end
      end

      it "returns the organization's referrers" do
        get :index
        expect(assigns(:referrers)).to eq(referrers)
      end

      context "with other organizations" do
        let!(:other_referrers) { create_list(:referrer, 2) }
        it "does not return the other organization's referrers" do
          get :index
          expect(assigns(:referrers)).not_to include(other_referrers)
        end
      end
    end
  end
end
