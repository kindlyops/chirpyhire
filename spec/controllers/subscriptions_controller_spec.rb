require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe "#create" do
    context "with an existing subscription" do
      let(:organization) { create(:organization_with_phone_and_owner) }
      let(:lead) { create(:lead, organization: organization) }

      let(:params) do
        {
          "To" => organization.phone_number,
          "From" => lead.phone_number,
          "body" => "CARE"
        }
      end

      before(:each) do
        lead.subscribe
      end

      it "let's the user know they are already subscribed" do
        post :create, params
        expect(response.body).to include("You are already subscribed. Thanks for your interest in #{organization.name}.")
      end
    end

    context "without an active subscription" do
      it "subscribes the user" do
      end

      it "thanks the user for subscribing" do
      end

      context "without an existing lead" do
        it "creates a lead" do
        end

        context "without an existing user" do
          it "creates a user with the phone number" do
          end
        end
      end
    end
  end

  describe "#destroy" do
    context "without an existing subscription" do
      it "let's the user know they are not subscribed" do
      end
    end

    context "with an existing subscription" do
      it "soft deletes the subscription" do
      end

      it "thanks the user and lets them know they are unsubscribed" do
      end
    end
  end
end
