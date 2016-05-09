require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:organization) { create(:organization, :with_phone, :with_owner) }
  let(:phone_number) { "+15555555555" }
  describe "#create" do
    let(:params) do
      {
        "To" => organization.phone_number,
        "From" => phone_number,
        "Body" => "START",
        "MessageSid" => "123"
      }
    end

    it "creates a message" do
      expect {
        post :create, params
      }.to change{Message.count}.by(1)
    end

    context "with an existing user" do
      let!(:user) { create(:user, organization: organization, phone_number: phone_number) }

      context "with an existing candidate" do
        let!(:candidate) { create(:candidate, user: user) }

        context "with an active subscription" do
          before(:each) do
            candidate.subscribe
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

      context "without an existing candidate" do
        it "creates a candidate for the user" do
          expect {
            post :create, params
          }.to change{user.reload.candidate.present?}.from(false).to(true)
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

      it "creates a candidate for the user" do
        expect {
          post :create, params
        }.to change{organization.candidates.count}.by(1)
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
        "Body" => "STOP",
        "MessageSid" => "123"
      }
    end

    it "creates a message" do
      expect {
        post :destroy, params
      }.to change{Message.count}.by(1)
    end

    context "with an existing user" do
      let!(:user) { create(:user, organization: organization, phone_number: phone_number) }

      context "with an existing subscription" do
        let(:candidate) { create(:candidate, user: user) }
        before(:each) do
          candidate.subscribe
        end

        it "soft deletes the subscription" do
          subscription = candidate.subscription

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
