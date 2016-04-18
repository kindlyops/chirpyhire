require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:organization) { create(:organization_with_phone_and_owner) }
  let(:phone_number) { "+15555555555" }
  describe "#create" do
    let(:params) do
      {
        "To" => organization.phone_number,
        "From" => phone_number,
        "Body" => "START"
      }
    end

    context "with an existing user" do
      let!(:user) { create(:user, phone_number: phone_number) }

      context "with an existing lead" do
        let!(:lead) { create(:lead, user: user, organization: organization) }

        context "with an active subscription" do
          before(:each) do
            user.subscribe_to(organization)
          end

          it "let's the user know they are already subscribed" do
            post :create, params
            expect(response.body).to include("You are already subscribed. Thanks for your interest in #{organization.name}.")
          end
        end

        context "without an active subscription" do
          it "creates a subscription" do
            expect {
              post :create, params
            }.to change{Subscription.count}.by(1)
          end

          it "instructs them how to opt out" do
            post :create, params
            expect(response.body).to include("reply STOP")
          end
        end
      end

      context "without an existing lead" do
        it "creates a lead for the user" do
          expect {
            post :create, params
          }.to change{organization.leads.where(user: user).count}.by(1)
        end

        it "creates a subscription" do
          expect {
            post :create, params
          }.to change{Subscription.count}.by(1)
        end
      end
    end

    context "without an existing user" do
      it "creates a user using the phone number" do
        expect {
          post :create, params
        }.to change{User.where(phone_number: phone_number).count}.by(1)
      end

      it "creates a lead for the user" do
        expect {
          post :create, params
        }.to change{organization.leads.count}.by(1)
      end

      it "creates a subscription" do
        expect {
          post :create, params
        }.to change{Subscription.count}.by(1)
      end
    end
  end

  describe "#destroy" do
    let(:params) do
      {
        "To" => organization.phone_number,
        "From" => phone_number,
        "Body" => "STOP"
      }
    end

    context "with an existing user" do
      let!(:user) { create(:user, phone_number: phone_number) }

      context "with an existing subscription" do
        before(:each) do
          user.subscribe_to(organization)
        end

        it "soft deletes the subscription" do
          subscription = user.subscription_to(organization)

          expect{
            delete :destroy, params
          }.to change{subscription.reload.deleted?}.from(false).to(true)
        end

        it "thanks the user and lets them know they are unsubscribed" do
          delete :destroy, params
          expect(response.body).to include("You are unsubscribed. To subscribe reply with START. Thanks for your interest in #{organization.name}.")
        end
      end

      context "without an existing subscription" do
        it "let's the user know they are not subscribed" do
          delete :destroy, params
          expect(response.body).to include("You were not subscribed. To subscribe reply with START.")
        end
      end
    end

    context "without an existing user" do
      it "let's the user know they are not subscribed" do
        delete :destroy, params
        expect(response.body).to include("You were not subscribed. To subscribe reply with START.")
      end
    end
  end
end
