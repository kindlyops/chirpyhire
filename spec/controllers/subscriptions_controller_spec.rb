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
    let!(:subscription) { create(:subscription, organization: organization, plan: plan) }

    context "with new trialing subscription" do
      it "assigns the trialing subscription as @subscription" do
        get :new, params: {}
        expect(assigns(:subscription)).to eq(subscription)
      end
    end

    context "with existing subscription tied to stripe" do
      let!(:subscription) { create(:subscription, organization: organization, plan: plan, stripe_id: "sub_123") }

      it "redirects to edit" do
        get :new, params: {}
        expect(response).to redirect_to(edit_subscription_path(subscription))
      end
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
    context "with new trialing subscription" do
      let!(:subscription) { create(:subscription, organization: organization, plan: plan) }

      context "with valid params" do
        let(:stripe_token) { "token" }

        context "not testing the Process Service" do
          before(:each) do
            allow(Payment::Subscriptions::Process).to receive(:call)
          end

          it "sets the stripe token on the organization" do
            expect {
              post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
            }.to change{organization.reload.stripe_token}.from(nil).to(stripe_token)
          end

          it "does not create a new subscription" do
            expect {
              post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
            }.not_to change(Subscription, :count)
          end

          it "assigns the trialing subscription as @subscription" do
            post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
            expect(assigns(:subscription)).to eq(subscription)
          end

          it "redirects to show route" do
            post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}

            expect(response).to redirect_to(subscription_path(subscription))
          end

          it "activates the subscription" do
            expect {
              post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
            }.to change{subscription.reload.state}.from("trialing").to("active")
          end

          it "calls the SurveyAdvancer service" do
            expect(SurveyAdvancer).to receive(:call).with(organization)
            post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
          end
        end

        context "when there is a Payment Card Error" do
          let(:error_message) { "Your card was declined." }

          before(:each) do
            stripe_error = Struct.new(:message).new(error_message)
            allow(Payment::Subscriptions::Process).to receive(:call).and_raise(Payment::CardError.new(stripe_error))
          end

          it "renders new" do
            post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
            expect(response).to render_template("new")
          end

          it "displays the error to the user and asks if they need help" do
            post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
            expect(flash[:alert]).to match(error_message)
          end
        end

        it "calls Process Service" do
          expect(Payment::Subscriptions::Process).to receive(:call)
          post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
        end
      end

      context "with invalid params" do
        it "assigns the trialing subscription as @subscription" do
          post :create, params: {subscription: invalid_attributes}
          expect(assigns(:subscription)).to eq(subscription)
        end

        it "renders the new template" do
          post :create, params: {subscription: invalid_attributes}
          expect(response).to render_template("new")
        end

        it "does not activate the subscription" do
          expect {
            post :create, params: {subscription: invalid_attributes}
          }.not_to change{subscription.reload.state}
        end

        it "does not set the stripe token on the organization" do
          expect {
            post :create, params: {subscription: invalid_attributes}
          }.not_to change{organization.reload.stripe_token}
        end

        it "does not call the Process Service" do
          expect(Payment::Subscriptions::Process).not_to receive(:call)
          post :create, params: {subscription: invalid_attributes}
        end
      end
    end

    context "with existing subscription tied to stripe" do
      let!(:subscription) { create(:subscription, organization: organization, plan: plan, stripe_id: "sub_123") }
      let(:stripe_token) { "token" }

      it "redirects to edit" do
        post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}

        expect(response).to redirect_to(edit_subscription_path(subscription))
      end

      it "does not set the stripe token on the organization" do
        expect {
          post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
        }.not_to change{organization.reload.stripe_token}
      end

      it "does not call the Process Service" do
        expect(Payment::Subscriptions::Process).not_to receive(:call)
        post :create, params: {stripe_token: stripe_token, subscription: valid_attributes}
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { quantity: 2 }
      }

      let!(:subscription) { organization.create_subscription valid_attributes }

      context "not testing the Update Service" do
        before(:each) do
          allow(Payment::Subscriptions::Update).to receive(:call).and_return(true)
        end

        it "assigns the requested subscription as @subscription" do
          put :update, params: {id: subscription.to_param, subscription: valid_attributes}
          expect(assigns(:subscription)).to eq(subscription)
        end

        it "redirects to the subscription" do
          put :update, params: {id: subscription.to_param, subscription: valid_attributes}
          expect(response).to redirect_to(subscription_path(subscription))
        end

        it "calls the SurveyAdvancer service" do
          expect(SurveyAdvancer).to receive(:call).with(subscription.organization)
          put :update, params: {id: subscription.to_param, subscription: valid_attributes}
        end
      end

      context "when there is a Payment Card Error" do
        let(:error_message) { "Your card was declined." }

        before(:each) do
          stripe_error = Struct.new(:message).new(error_message)
          allow(Payment::Subscriptions::Update).to receive(:call).and_raise(Payment::CardError.new(stripe_error))
        end

        it "renders edit" do
          put :update, params: {id: subscription.to_param, subscription: valid_attributes}
          expect(response).to render_template("edit")
        end

        it "displays the error to the user and asks if they need help" do
          put :update, params: {id: subscription.to_param, subscription: valid_attributes}
          expect(flash[:alert]).to match(error_message)
        end
      end

      it "calls Update Service" do
        expect(Payment::Subscriptions::Update).to receive(:call)
        put :update, params: {id: subscription.to_param, subscription: valid_attributes}
      end
    end
  end

  describe "DELETE #destroy" do
    let(:valid_attributes) {
      { plan_id: plan.id, quantity: 1, state: "active" }
    }

    let!(:subscription) { organization.create_subscription valid_attributes }

    context "not testing the Cancel Service" do
      before(:each) do
        allow(Payment::Subscriptions::Cancel).to receive(:call).with(subscription)
      end

      it "cancels the requested subscription" do
        expect {
          delete :destroy, params: {id: subscription.to_param}
        }.to change{subscription.reload.state}.from("active").to("canceled")
      end

      it "redirects to the subscriptions edit subscription" do
        delete :destroy, params: {id: subscription.to_param}
        expect(response).to redirect_to(subscription_path(subscription))
      end
    end

    it "calls the Cancel Service" do
      expect(Payment::Subscriptions::Cancel).to receive(:call).with(subscription)
      delete :destroy, params: {id: subscription.to_param}
    end
  end

end
