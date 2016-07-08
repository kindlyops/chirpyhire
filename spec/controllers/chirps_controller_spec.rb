require 'rails_helper'

RSpec.describe ChirpsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }
  let(:admin) { create(:user, :with_account, organization: organization) }

  before(:each) do
    sign_in(admin.account)
  end

  describe "#new" do
    context "xhr" do
      it "assigns a new chirp" do
        get :new, xhr: true, params: { user_id: user.id }

        expect(assigns(:chirp)).to be_a(Chirp)
        expect(assigns(:chirp)).not_to be_persisted
      end

      it "is ok" do
        get :new, xhr: true, params: { user_id: user.id }
        expect(response).to be_ok
      end
    end
  end

  describe "#create" do
    let(:chirp_params) do
      {
        user_id: user.id,
        chirp: {
          body: Faker::Lorem.sentence
        }
      }
    end

    context "xhr" do
      it "creates a new chirp" do
        expect {
          post :create, xhr: true, params: chirp_params
        }.to change{user.chirps.count}.by(1)
      end

      it "sends the chirp" do
        expect {
          post :create, xhr: true, params: chirp_params
        }.to change{FakeMessaging.messages.count}.by(1)
      end
    end
  end
end
