require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:organization) { create(:organization, :with_contact) }
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

    context "with an existing user" do
      let!(:user) { create(:user, organization: organization, phone_number: phone_number) }

      it "creates a chirp" do
        expect {
          post :create, params
        }.to change{user.chirps.count}.by(1)
      end

      context "with an existing candidate" do
        let!(:candidate) { create(:candidate, user: user) }

        context "with an active subscription" do
          before(:each) do
            candidate.update(subscribed: true)
          end

          it "lets the user know they were already subscribed" do
            post :create, params
            expect(FakeMessaging.messages.last.body).to include("You are already subscribed.")
          end
        end

        context "without an active subscription" do
          it "sets the subscription flag to true" do
            post :create, params
            expect(candidate.reload.subscribed?).to eq(true)
          end

          it "creates a subscribe Automaton Job" do
            expect {
              post :create, params
            }.to have_enqueued_job(AutomatonJob).with(user, "subscribe")
          end
        end
      end

      context "without an existing candidate" do
        it "creates a candidate for the user" do
          expect {
            post :create, params
          }.to change{user.reload.candidate.present?}.from(false).to(true)
        end

        it "sets the subscription flag to true" do
          post :create, params
          expect(user.candidate.subscribed?).to eq(true)
        end
      end
    end

    context "without an existing user" do
      it "creates a user using the phone number" do
        expect {
          post :create, params
        }.to change{User.where(phone_number: phone_number).count}.by(1)
      end

      it "creates a chirp" do
        expect {
          post :create, params
        }.to change{Chirp.count}.by(1)
      end

      it "creates a candidate for the user" do
        expect {
          post :create, params
        }.to change{organization.candidates.count}.by(1)
      end

      it "sets the subscription flag to true" do
        post :create, params
        expect(User.find_by(phone_number: phone_number).candidate.subscribed?).to eq(true)
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

    context "with a user" do
      let!(:user) { create(:user, organization: organization, phone_number: phone_number) }

      it "creates a chirp" do
        expect {
          post :create, params
        }.to change{user.chirps.count}.by(1)
      end

      context "with an existing subscribed candidate" do
        let!(:candidate) { create(:candidate, user: user, subscribed: true) }

        it "creates a chirp" do
          expect {
            post :create, params
          }.to change{user.chirps.count}.by(1)
        end

        it "sets the subscribed flag to false" do
          expect{
            delete :destroy, params
          }.to change{candidate.reload.subscribed?}.from(true).to(false)
        end

        it "lets the user know they are unsubscribed now" do
          delete :destroy, params

          expect(FakeMessaging.messages.last.body).to include("You are unsubscribed. To subscribe reply with START.")
        end
      end

      context "without an existing subscription" do
        let(:candidate) { create(:candidate, user: user) }

        it "lets the user know they were not subscribed" do
          delete :destroy, params

          expect(FakeMessaging.messages.last.body).to include("To subscribe reply with START.")
        end
      end
    end

    context "without an existing user" do
      it "creates a user" do
        expect {
          delete :destroy, params
        }.to change{organization.users.count}.by(1)
      end

      it "creates a chirp" do
        expect {
          delete :destroy, params
        }.to change{Chirp.count}.by(1)
      end

      it "creates a candidate" do
        expect {
          delete :destroy, params
        }.to change{organization.candidates.count}.by(1)
      end

      it "lets the user know they aren't subscribed" do
        delete :destroy, params

        expect(FakeMessaging.messages.last.body).to include("To subscribe reply with START.")
      end
    end
  end
end
