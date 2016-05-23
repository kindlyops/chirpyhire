require 'rails_helper'

RSpec.describe RulesController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:account) { user.account }
  let(:organization) { user.organization }
  let(:automation) { create(:automation, :with_rule, organization: organization) }
  let!(:rule) { automation.rules.first }

  before(:each) do
    sign_in(account)
  end

  describe "#new" do
    it "is ok" do
      get :new, automation_id: automation.id
      expect(response).to be_ok
    end

    it "assigns a new rule" do
      get :new, automation_id: automation.id
      expect(assigns(:rule)).to be_a(Rule)
      expect(assigns(:rule).id).to eq(nil)
    end
  end

  describe "#edit" do
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

      let(:trigger) { create(:trigger, organization: organization) }
      let(:notice) { create(:notice, template: notice_template) }
      let(:action) { notice.create_action(organization: organization) }

      let(:rule_params) do
        { automation_id: automation.id,
          rule: {
          trigger_id: trigger.id,
          action_id: action.id
        } }
      end

      it "creates a rule" do
        expect {
          post :create, rule_params
        }.to change{automation.rules.count}.by(1)
      end

      it "redirects to index" do
        post :create, rule_params
        expect(response).to redirect_to(rule_path(Rule.last))
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
          { automation_id: automation.id,
            rule: {
            trigger_id: 1,
            action_id: 1023
        } }
      end

      it "does not create a rule" do
        expect {
          post :create, invalid_params
        }.not_to change{automation.rules.count}
      end

      it "renders the new template" do
        post :create, invalid_params

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
          put :update, rule_params
        }.to change{rule.reload.enabled?}.from(true).to(false)
      end

      it "redirects to index" do
        put :update, rule_params
        expect(response).to redirect_to(rule_path(rule))
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { id: rule.id,
          rule: {
          trigger_id: 1,
          action_id: 1023
      } }
      end

      it "does not create a rule" do
        expect {
          put :update, invalid_params
        }.not_to change{automation.rules.count}
      end

      it "renders the show template" do
        put :update, invalid_params

        expect(response).to render_template("show")
      end
    end
  end
end
