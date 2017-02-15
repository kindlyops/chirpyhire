require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  let(:user) { account.user }

  before(:each) do
    sign_in(account)
  end

  describe '#index' do
    it 'is OK' do
      get :index
      expect(response).to be_ok
    end

    context 'with candidates' do
      let!(:candidates) { create_list(:candidate, 3, organization: organization) }

      it "returns the organization's candidates" do
        get :index
        expect(assigns(:candidates)).to match_array(candidates)
      end

      context 'with other organizations' do
        let!(:other_candidates) { create_list(:candidate, 2) }
        it "does not return the other organization's candidates" do
          get :index
          expect(assigns(:candidates)).not_to include(other_candidates)
        end
      end
    end
  end
end
