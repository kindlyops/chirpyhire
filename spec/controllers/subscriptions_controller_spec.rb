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

  describe "GET #show" do
    it "assigns the requested subscription as @subscription" do
      subscription = organization.create_subscription valid_attributes
      get :show, params: {id: subscription.to_param}
      expect(assigns(:subscription)).to eq(subscription)
    end
  end

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
      it "creates a new Subscription" do
        expect {
          post :create, params: {subscription: valid_attributes}
        }.to change(Subscription, :count).by(1)
      end

      it "assigns a newly created subscription as @subscription" do
        post :create, params: {subscription: valid_attributes}
        expect(assigns(:subscription)).to be_a(Subscription)
        expect(assigns(:subscription)).to be_persisted
      end

      it "renders a json of the created subscription" do
        post :create, params: {subscription: valid_attributes}
        expect(response_json["id"]).to eq(Subscription.last.id)
        expect(response_json["state"]).to eq(Subscription.last.state)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved subscription as @subscription" do
        post :create, params: {subscription: invalid_attributes}
        expect(assigns(:subscription)).to be_a_new(Subscription)
      end

      it "renders json of the error" do
        post :create, params: {subscription: invalid_attributes}
        expect(response_json["error"]).to eq("Quantity can't be blank")
        expect(response_json["id"]).to eq(nil)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
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

    context "with invalid params" do
      it "assigns the subscription as @subscription" do
        subscription = organization.create_subscription valid_attributes
        put :update, params: {id: subscription.to_param, subscription: invalid_attributes}
        expect(assigns(:subscription)).to eq(subscription)
      end

      it "re-renders the 'edit' template" do
        subscription = organization.create_subscription valid_attributes
        put :update, params: {id: subscription.to_param, subscription: invalid_attributes}
        expect(response).to render_template("edit")
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
