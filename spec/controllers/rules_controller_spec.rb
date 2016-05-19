require 'rails_helper'

RSpec.describe RulesController, type: :controller do
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

    it "assigns a new rule" do
      get :new
      expect(assigns(:rule)).to be_a(Rule)
      expect(assigns(:rule).id).to eq(nil)
    end
  end

  describe "#edit" do
    let(:rule) { create(:rule, organization: organization) }

    it "is ok" do
      get :edit, id: rule.id
      expect(response).to be_ok
    end

    it "assigns the rule" do
      get :edit, id: rule.id
      expect(assigns(:rule)).to be_a(Rule)
      expect(assigns(:rule).id).to eq(rule.id)
    end
  end

  describe "#create" do
    context "with valid rule params" do
      let(:template) { create(:template, organization: organization)}
      let(:notice_template) { create(:template, organization: organization)}

      let(:question) { create(:question, template: template) }
      let(:notice) { create(:notice, template: notice_template) }

      let(:rule_params) do
        { rule: {
          trigger_type: "Question",
          trigger_id: question.id,
          event: "answer",
          action_id: notice.id,
          action_type: notice.class.to_s
        } }
      end

      it "creates a rule" do
        expect {
          post :create, rule_params
        }.to change{organization.rules.count}.by(1)
      end

      it "redirects to index" do
        post :create, rule_params
        expect(response).to redirect_to(rules_path)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { rule: {
          trigger_type: "Foo",
          trigger_id: 1,
          event: "baz"
        } }
      end

      it "does not create a rule" do
        expect {
          post :create, invalid_params
        }.not_to change{organization.rules.count}
      end

      it "renders the new template" do
        post :create, invalid_params

        expect(response).to render_template("new")
      end
    end
  end

  describe "#update" do
    let!(:rule) { create(:rule, organization: organization) }

    context "with valid rule params" do
      let(:rule_params) do
        { id: rule.id,
          rule: {
          enabled: false
        } }
      end

      it "updates the rule" do
        expect {
          put :update, rule_params
        }.to change{rule.reload.enabled?}.from(true).to(false)
      end

      it "redirects to index" do
        put :update, rule_params
        expect(response).to redirect_to(rules_path)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { id: rule.id,
          rule: {
          trigger_type: "Foo",
          trigger_id: 1,
          event: "baz"
        } }
      end

      it "does not create a rule" do
        expect {
          put :update, invalid_params
        }.not_to change{organization.rules.count}
      end

      it "renders the edit template" do
        put :update, invalid_params

        expect(response).to render_template("edit")
      end
    end
  end

  describe "#destroy" do
    let!(:rule) { create(:rule, organization: organization) }

    it "destroys the rule" do
      expect {
        delete :destroy, id: rule.id
      }.to change{organization.rules.count}.by(-1)
    end
  end

  describe "#index" do
    it "is OK" do
      get :index
      expect(response).to be_ok
    end

    context "with rules" do
      let!(:rules) { create_list(:rule, 3, organization: organization) }

      it "returns the organization's rules" do
        get :index
        expect(assigns(:rules).map(&:id)).to eq(rules.map(&:id))
      end
    end
  end
end
