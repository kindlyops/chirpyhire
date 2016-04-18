require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe "#create" do
    let(:organization) { create(:organization_with_phone_and_owner) }
    let(:phone_number) { "+15555555555" }
    let(:params) do
      {
        "To" => organization.phone_number,
        "From" => phone_number,
        "body" => "CARE"
      }
    end

    context "with an existing user" do
      let!(:user) { create(:user, phone_number: phone_number) }

      context "with an existing lead" do
        let!(:lead) { create(:lead, user: user, organization: organization) }

        context "with an active subscription" do
          before(:each) do
            lead.subscribe
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
        it "creates a lead" do
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

    context "without an existing user" do
      it "creates a user using the phone number" do
        expect {
          post :create, params
        }.to change{User.where(phone_number: phone_number).count}.by(1)
      end

      it "creates a lead" do
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
