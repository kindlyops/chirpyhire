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
      expect(assigns(:trigger)).to be_a(Trigger)
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
      expect(assigns(:trigger)).to be_a(Trigger)
      expect(assigns(:trigger).id).to eq(trigger.id)
    end
  end

  describe "#create" do
    context "with valid trigger params" do
      let(:template) { create(:template, organization: organization)}
      let(:question) { create(:question, template: template) }

      let(:trigger_params) do
        { trigger: {
          observable_type: "Question",
          observable_id: question.id,
          event: "answer"
        } }
      end

      it "creates a trigger" do
        expect {
          post :create, trigger_params
        }.to change{organization.triggers.count}.by(1)
      end

      it "redirects to index" do
        post :create, trigger_params
        expect(response).to redirect_to(triggers_path)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { trigger: {
          observable_type: "Foo",
          observable_id: 1,
          event: "baz"
        } }
      end

      it "does not create a trigger" do
        expect {
          post :create, invalid_params
        }.not_to change{organization.triggers.count}
      end

      it "renders the new template" do
        post :create, invalid_params

        expect(response).to render_template("new")
      end
    end
  end

  describe "#update" do
    let!(:trigger) { create(:trigger, organization: organization) }

    context "with valid trigger params" do
      let(:trigger_params) do
        { id: trigger.id,
          trigger: {
          enabled: false
        } }
      end

      it "updates the trigger" do
        expect {
          put :update, trigger_params
        }.to change{trigger.reload.enabled?}.from(true).to(false)
      end

      it "redirects to index" do
        put :update, trigger_params
        expect(response).to redirect_to(triggers_path)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { id: trigger.id,
          trigger: {
          observable_type: "Foo",
          observable_id: 1,
          event: "baz"
        } }
      end

      it "does not create a trigger" do
        expect {
          put :update, invalid_params
        }.not_to change{organization.triggers.count}
      end

      it "renders the edit template" do
        put :update, invalid_params

        expect(response).to render_template("edit")
      end
    end
  end

  describe "#destroy" do
    let!(:trigger) { create(:trigger, organization: organization) }

    it "destroys the trigger" do
      expect {
        delete :destroy, id: trigger.id
      }.to change{organization.triggers.count}.by(-1)
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
