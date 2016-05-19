require 'rails_helper'

RSpec.describe RulePolicy do
  subject { RulePolicy.new(account, rule) }

  let(:rule) { create(:rule) }

  let(:resolved_scope) { RulePolicy::Scope.new(account, Rule.all).resolve }

  context "being a visitor" do
    let(:account) { nil }

    it { should forbid_new_and_create_actions }
    it { should forbid_edit_and_update_actions }
    it { should forbid_action(:destroy) }
  end

  context "having an account" do
    context "account is on a different organization" do
      let(:account) { create(:account) }

      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }

      it 'excludes rule in resolved scope' do
        expect(resolved_scope).not_to include(rule)
      end
    end

    context "account is on the same organization as the rule" do
      let(:user) { create(:user, organization: rule.organization) }
      let(:account) { create(:account, user: user) }

      it { should permit_new_and_create_actions }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
      it { should permit_mass_assignment_of(:enabled) }
      it { should permit_mass_assignment_of(:trigger_type) }
      it { should permit_mass_assignment_of(:trigger_id) }
      it { should permit_mass_assignment_of(:action_id) }
      it { should permit_mass_assignment_of(:action_type) }
      it { should permit_mass_assignment_of(:event) }

      it 'includes rule in resolved scope' do
        expect(resolved_scope).to include(rule)
      end
    end
  end
end
