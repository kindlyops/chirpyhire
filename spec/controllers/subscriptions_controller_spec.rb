require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:organization) { create(:organization, :with_account) }
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

      context "with an active subscription" do
        before(:each) do
          user.update(subscribed: true)
        end

        it "creates a message" do
          expect {
            post :create, params: params
          }.to change{user.messages.count}.by(1)
        end

        it "lets the user know they were already subscribed" do
          post :create, params: params
          expect(FakeMessaging.messages.last.body).to include("You are already subscribed.")
        end
      end

      context "without an active subscription" do
        it "sets the subscription flag to true" do
          post :create, params: params
          expect(user.reload.subscribed?).to eq(true)
        end

        it "creates a subscribe Automaton Job" do
          expect {
            post :create, params: params
          }.to have_enqueued_job(AutomatonJob).with(user, "subscribe")
        end

        context "when the AutomatonJob raises" do
          it "doesn't set the subscribe flag" do
            allow(AutomatonJob).to receive(:perform_later).and_raise(Redis::ConnectionError)
            expect {
              post :create, params: params
            }.to raise_error(Redis::ConnectionError)
            expect(user.reload.subscribed?).to eq(false)
          end
        end
      end

      context "with an existing candidate" do
        let!(:candidate) { create(:candidate, user: user) }

        it "does not create a candidate for the user" do
          expect {
            post :create, params: params
          }.not_to change{user.reload.candidate.present?}
        end
      end

      context "without an existing candidate" do
        it "creates a candidate for the user" do
          expect {
            post :create, params: params
          }.to change{user.reload.candidate.present?}.from(false).to(true)
        end

        it "sets the user subscription flag to true" do
          expect {
            post :create, params: params
          }.to change{user.reload.subscribed?}.from(false).to(true)
        end
      end
    end

    context "without an existing user" do
      it "creates a user using the phone number" do
        expect {
          post :create, params: params
        }.to change{User.where(phone_number: phone_number).count}.by(1)
      end

      it "creates a message" do
        expect {
          post :create, params: params
        }.to change{Message.count}.by(1)
      end

      it "creates a candidate for the user" do
        expect {
          post :create, params: params
        }.to change{organization.candidates.count}.by(1)
      end

      it "sets the subscription flag to true" do
        post :create, params: params
        expect(User.find_by(phone_number: phone_number).subscribed?).to eq(true)
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

      it "creates a message" do
        expect {
          delete :destroy, params: params
        }.to change{user.messages.count}.by(1)
      end

      context "that is subscribed" do
        before(:each) do
          user.update(subscribed: true)
        end

        it "sets the user subscription flag to false" do
          expect {
            delete :destroy, params: params
          }.to change{user.reload.subscribed?}.from(true).to(false)
        end

        it "does not send a message" do
          expect {
            delete :destroy, params: params
          }.not_to change{Message.count}
        end
      end

      context "without an existing subscription" do
        it "lets the user know they were not subscribed" do
          delete :destroy, params: params

          expect(FakeMessaging.messages.last.body).to include("To subscribe reply with START.")
        end
      end
    end

    context "without an existing user" do
      it "creates a user" do
        expect {
          delete :destroy, params: params
        }.to change{organization.users.count}.by(1)
      end

      it "creates a message" do
        expect {
          delete :destroy, params: params
        }.to change{Message.count}.by(1)
      end

      it "does not create a candidate" do
        expect {
          delete :destroy, params: params
        }.not_to change{organization.candidates.count}
      end

      it "lets the user know they aren't subscribed" do
        delete :destroy, params: params

        expect(FakeMessaging.messages.last.body).to include("To subscribe reply with START.")
      end
    end
  end
end
