require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  let(:user) { account.user }

  before(:each) do
    sign_in(account)
  end

  describe "#index" do
    it "is OK" do
      get :index
      expect(response).to be_ok
    end


    context "with candidates" do
      let(:qualified_stage) { organization.qualified_stage }
      let!(:candidates) { create_list(:candidate, 3, stage: qualified_stage, organization: organization) }

      context "geojson" do
        context "with candidates with addresses without phone numbers" do
          let!(:candidates) { create_list(:candidate, 3, :with_address, stage: qualified_stage, organization: organization) }

          it "is OK" do
            get :index, format: :geojson
            expect(response).to be_ok
          end
        end
      end

      it "returns the organization's candidates" do
        get :index
        expect(assigns(:candidates)).to match_array(candidates)
      end

      context "order" do
        let(:potential_stage) { organization.potential_stage }
        let!(:old_candidate) { create(:candidate, id: 10, stage: potential_stage, organization: organization) }
        let!(:recent_candidate) { create(:candidate, id: 11, stage: potential_stage, organization: organization) }

        it "returns the most recent candidates first" do
          get :index, params: { stage_id: potential_stage.id }
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
