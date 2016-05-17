require 'rails_helper'

RSpec.describe TriggersController, type: :controller do
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

    context "with triggers" do
      let!(:triggers) { create_list(:trigger, 3, organization: organization) }

      it "returns the organization's triggers" do
        get :index
        expect(assigns(:triggers).map(&:id)).to eq(triggers.map(&:id))
      end

      context "with other organizations" do
        let!(:other_triggers) { create_list(:trigger, 2) }
        it "does not return the other organization's triggers" do
          get :index
          expect(assigns(:triggers)).not_to include(other_triggers)
        end
      end
    end
  end
end
