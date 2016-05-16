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
            candidate.update(subscribed: true)
          end

          it "creates an invalid_subscribe Automaton Job" do
            expect {
              post :create, params
            }.to have_enqueued_job(AutomatonJob).with(candidate, "invalid_subscribe")
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
            }.to have_enqueued_job(AutomatonJob).with(candidate, "subscribe")
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

    it "creates a message" do
      expect {
        post :destroy, params
      }.to change{Message.count}.by(1)
    end

    context "with an existing subscribed candidate" do
      let!(:user) { create(:user, organization: organization, phone_number: phone_number) }

      let(:candidate) { create(:candidate, user: user, subscribed: true) }

      it "sets the subscribed flag to false" do
        expect{
          delete :destroy, params
        }.to change{candidate.reload.subscribed?}.from(true).to(false)
      end

      it "creates an unsubscribe Automaton Job" do
        expect {
          delete :destroy, params
        }.to have_enqueued_job(AutomatonJob).with(candidate, "unsubscribe")
      end
    end

    context "without an existing subscription" do
      let!(:user) { create(:user, organization: organization, phone_number: phone_number) }

      let(:candidate) { create(:candidate, user: user) }

      it "creates an invalid_unsubscribe Automaton Job" do
        expect {
          delete :destroy, params
        }.to have_enqueued_job(AutomatonJob).with(candidate, "invalid_unsubscribe")
      end
    end

    context "without an existing user" do
      it "creates a user" do
        expect {
          delete :destroy, params
        }.to change{organization.users.count}.by(1)
      end

      it "creates a candidate" do
        expect {
          delete :destroy, params
        }.to change{organization.candidates.count}.by(1)
      end

      it "creates an invalid_unsubscribe Automaton Job" do
        expect {
          delete :destroy, params
        }.to have_enqueued_job(AutomatonJob).exactly(:once)
      end
    end
  end
end
