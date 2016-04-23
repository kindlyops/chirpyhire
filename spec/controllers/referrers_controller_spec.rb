require 'rails_helper'

RSpec.describe ReferrersController, type: :controller do
  context "not logged in" do
    describe "#index" do
      it "302s" do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end

  context "logged in" do
    let(:account) { create(:account, :with_organization) }
    let(:organization) { account.organization }

    before(:each) do
      sign_in(account)
    end

    describe "#index" do
      it "is OK" do
        get :index
        expect(response).to be_ok
      end

      context "with referrers" do
        let!(:referrers) { create_list(:referrer, 3, organization: organization) }

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
end
