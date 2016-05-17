require 'rails_helper'

RSpec.describe TriggersController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:account) { user.account }
  let(:organization) { user.organization }

  before(:each) do
    sign_in(account)
  end

  describe "#new" do
    it "is ok" do
      get :new
      expect(response).to be_ok
    end

    it "assigns a new trigger" do
      get :new
      expect(assigns(:trigger)).to be_a(TriggerPresenter)
      expect(assigns(:trigger).id).to eq(nil)
    end
  end

  describe "#edit" do
    let(:trigger) { create(:trigger, organization: organization) }

    it "is ok" do
      get :edit, id: trigger.id
      expect(response).to be_ok
    end

    it "assigns the trigger" do
      get :edit, id: trigger.id
      expect(assigns(:trigger)).to be_a(TriggerPresenter)
      expect(assigns(:trigger).id).to eq(trigger.id)
    end
  end

  describe "#index" do
    it "is OK" do
      get :index
      expect(response).to be_ok
    end

    context "with triggers" do
      let!(:triggers) { create_list(:trigger, 3, organization: organization) }

      it "returns the organization's triggers" do
        get :index
        expect(assigns(:triggers).map(&:id)).to eq(triggers.map(&:id))
      end
    end
  end
end
