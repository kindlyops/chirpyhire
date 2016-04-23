require 'rails_helper'

RSpec.describe LeadsController, type: :controller do
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

      context "with leads" do
        let!(:leads) { create_list(:lead, 3, organization: organization) }

        it "returns the organization's leads" do
          get :index
          expect(assigns(:leads)).to eq(leads)
        end

        context "with other organizations" do
          let!(:other_leads) { create_list(:lead, 2) }
          it "does not return the other organization's leads" do
            get :index
            expect(assigns(:leads)).not_to include(other_leads)
          end
        end
      end
    end
  end
end
