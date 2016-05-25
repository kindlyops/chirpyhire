require 'rails_helper'

RSpec.describe RulePolicy do
  subject { RulePolicy.new(account, rule) }

  let!(:automation) { create(:automation) }
  let!(:rule) { create(:rule) }

  let(:resolved_scope) { RulePolicy::Scope.new(automation, Rule.all).resolve }

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

    context "rule is on the same organization as the automation" do
      let(:account) { create(:account) }
      let(:automation) { create(:automation, :with_rule, organization: account.organization) }
      let!(:rule) { automation.rules.first }

      it { should permit_new_and_create_actions }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:show) }
      it { should permit_action(:destroy) }

      it { should permit_mass_assignment_of(:enabled) }
      it { should permit_mass_assignment_of(:trigger_id) }
      it { should permit_mass_assignment_of(:action_id) }

      it 'includes rule in resolved scope' do
        expect(resolved_scope).to include(rule)
      end
    end
  end
end
