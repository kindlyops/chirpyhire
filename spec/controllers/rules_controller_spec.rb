require 'rails_helper'

RSpec.describe RulesController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:account) { user.account }
  let(:organization) { user.organization }
  let(:rule) { create(:rule, organization: organization) }

  before(:each) do
    sign_in(account)
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
        expect(assigns(:rules)).to eq(rules)
      end

      context "with other organizations" do
        let!(:other_rules) { create_list(:rule, 2) }
        it "does not return the other organization's rules" do
          get :index
          expect(assigns(:rules)).not_to include(other_rules)
        end
      end
    end
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
    it "is ok" do
      get :edit, params: { id: rule.id }
      expect(response).to be_ok
    end

    it "assigns the rule" do
      get :edit, params: { id: rule.id }
      expect(assigns(:rule)).to be_a(Rule)
      expect(assigns(:rule).id).to eq(rule.id)
    end
  end

  describe "#create" do
    context "with valid rule params" do
      let(:template) { create(:template, organization: organization)}

      let(:rule_params) do
        { rule: {
          trigger: "subscribe",
          action_id: template.id,
          action_type: template.class
        } }
      end

      it "creates a rule" do
        expect {
          post :create, params: rule_params
        }.to change{organization.rules.count}.by(1)
      end

      it "redirects to index" do
        post :create, params: rule_params
        expect(response).to redirect_to(rule_path(Rule.last))
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
          { rule: {
            trigger: "subscribe",
            action_id: 1023,
            action_type: "Template"
        } }
      end

      it "does not create a rule" do
        expect {
          post :create, params: invalid_params
        }.not_to change{organization.rules.count}
      end

      it "renders the new template" do
        post :create, params: invalid_params

        expect(response).to render_template("new")
      end
    end
  end

  describe "#update" do
    context "with valid rule params" do
      let(:rule_params) do
        { id: rule.id,
          rule: {
          enabled: false
        } }
      end

      it "updates the rule" do
        expect {
          put :update, params: rule_params
        }.to change{rule.reload.enabled?}.from(true).to(false)
      end

      it "redirects to index" do
        put :update, params: rule_params
        expect(response).to redirect_to(rule_path(rule))
      end
    end
  end
end
