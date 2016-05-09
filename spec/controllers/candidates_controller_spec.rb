require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  context "not logged in" do
    describe "#index" do
      it "302s" do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end

  context "logged in" do
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
        let!(:users) { create_list(:user, 3, organization: organization) }
        let!(:candidates) do
          3.times.map do |i|
            create(:candidate, user: users[i-1])
          end
        end

        it "returns the organization's candidates" do
          get :index
          expect(assigns(:candidates)).to eq(candidates)
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
end
