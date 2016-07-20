require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
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

    context "with candidates" do
      let!(:candidates) { create_list(:candidate, 3, status: "Screened", organization: organization) }

      it "returns the organization's candidates" do
        get :index
        expect(assigns(:candidates)).to match_array(candidates)
      end

      context "order" do
        let!(:old_candidate) { create(:candidate, id: 10, organization: organization) }
        let!(:recent_candidate) { create(:candidate, id: 11, organization: organization) }

        it "returns the most recent candidates first" do
          get :index, params: { status: "Potential" }
          expect(assigns(:candidates)).to eq([recent_candidate, old_candidate])
        end
      end

      context "with other organizations" do
        let!(:other_candidates) { create_list(:candidate, 2) }
        it "does not return the other organization's candidates" do
          get :index
          expect(assigns(:candidates)).not_to include(other_candidates)
        end
      end
    end
  end
end
