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
      let!(:tasks) { create_list(:task, 3, organization: organization) }

      it "returns the organization's tasks" do
        get :show
        expect(assigns(:inbox).tasks.map(&:id)).to match_array(tasks.map(&:id))
      end

      context "with done tasks" do
        let!(:task) { create(:task, outstanding: false, organization: organization) }

        it "does not include done tasks" do
          get :show
          expect(assigns(:inbox).tasks).not_to include(task)
        end
      end

      context "with other organizations" do
        let!(:other_tasks) { create_list(:task, 2) }
        it "does not return the other organization's tasks" do
          get :show
          expect(assigns(:inbox).tasks).not_to include(other_tasks)
        end
      end
    end
  end
end
