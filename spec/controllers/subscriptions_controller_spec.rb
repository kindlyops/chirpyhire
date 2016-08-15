require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:account) { create(:account) }
  let(:organization) { account.organization }
  let(:plan) { create(:plan) }

  before(:each) do
    sign_in(account)
  end

  let(:valid_attributes) {
    { plan_id: plan.id, quantity: 1 }
  }

  let(:invalid_attributes) {
    { plan_id: plan.id }
  }

  describe "GET #new" do
    it "assigns a new subscription as @subscription" do
      get :new, params: {}
      expect(assigns(:subscription)).to be_a_new(Subscription)
    end
  end

  describe "GET #edit" do
    it "assigns the requested subscription as @subscription" do
      subscription = organization.create_subscription valid_attributes
      get :edit, params: {id: subscription.to_param}
      expect(assigns(:subscription)).to eq(subscription)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:stripe_token) { "token" }

      it "sets the stripe token on the organization" do
        expect {
          post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
        }.to change{organization.reload.stripe_token}.from(nil).to(stripe_token)
      end

      it "kicks off a job to process the subscription" do
        expect{
          post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
        }.to have_enqueued_job(Payment::ProcessSubscriptionJob)
      end

      it "creates a new Subscription" do
        expect {
          post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
        }.to change(Subscription, :count).by(1)
      end

      it "assigns a newly created subscription as @subscription" do
        post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
        expect(assigns(:subscription)).to be_a(Subscription)
        expect(assigns(:subscription)).to be_persisted
      end

      it "redirects to edit route" do
        post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}

        expect(response).to redirect_to(edit_subscription_path(subscription))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved subscription as @subscription" do
        post :create, params: {subscription: invalid_attributes}
        expect(assigns(:subscription)).to be_a_new(Subscription)
      end

      it "renders the new template" do
        post :create, params: {subscription: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { quantity: 2 }
      }

      it "updates the requested subscription" do
        subscription = organization.create_subscription valid_attributes
        put :update, params: {id: subscription.to_param, subscription: new_attributes}
        subscription.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested subscription as @subscription" do
        subscription = organization.create_subscription valid_attributes
        put :update, params: {id: subscription.to_param, subscription: valid_attributes}
        expect(assigns(:subscription)).to eq(subscription)
      end

      it "redirects to the subscription" do
        subscription = organization.create_subscription valid_attributes
        put :update, params: {id: subscription.to_param, subscription: valid_attributes}
        expect(response).to redirect_to(subscription)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested subscription" do
      subscription = organization.create_subscription valid_attributes
      expect {
        delete :destroy, params: {id: subscription.to_param}
      }.to change(Subscription, :count).by(-1)
    end

    it "redirects to the subscriptions list" do
      subscription = organization.create_subscription valid_attributes
      delete :destroy, params: {id: subscription.to_param}
      expect(response).to redirect_to(subscriptions_url)
    end
  end

end
