require 'rails_helper'

RSpec.describe InboxesController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:account) { user.account }
  let(:organization) { user.organization }

  before(:each) do
    sign_in(account)
  end

  describe "#show" do
    it "is OK" do
      get :show
      expect(response).to be_ok
    end

    context "with tasks" do
      let(:chirps) { create_list(:chirp, 3, user: user) }
      let!(:tasks) { chirps.map {|c| c.activities.last } }

      it "returns the organization's tasks" do
        get :show
        expect(assigns(:inbox).tasks.map(&:id)).to match_array(tasks.map(&:id))
      end

      context "with done tasks" do
        let(:inquiry) { create(:inquiry, user: user) }
        let!(:task) { inquiry.activities.last }

        it "does not include done tasks" do
          get :show
          expect(assigns(:inbox).tasks).not_to include(task)
        end
      end

      context "with other organizations" do
        let(:other_chirps) { create_list(:chirp, 2, user: user) }
        let!(:other_tasks) { other_chirps.map {|c| c.activities.last } }

        it "does not return the other organization's tasks" do
          get :show
          expect(assigns(:inbox).tasks).not_to include(other_tasks)
        end
      end
    end
  end
end
