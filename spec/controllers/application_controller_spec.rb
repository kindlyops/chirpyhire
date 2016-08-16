require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  context "not logged in" do
    describe "#index" do
      it "302s" do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end

  context "logged in" do
    let(:account) { create(:account) }

    before(:each) do
      sign_in(account)
    end

    context "canceled subscription" do
      let!(:subscription) { create(:subscription, organization: account.organization, state: "canceled") }

      controller do
        skip_after_action :verify_policy_scoped

        def index
          head :ok
        end
      end

      it "redirects to show_subscription page" do
        get :index
        expect(response).to redirect_to(subscription)
      end
    end
  end
end
