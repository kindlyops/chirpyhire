require 'rails_helper'

RSpec.describe TriggerPolicy do
  subject { TriggerPolicy.new(account, trigger) }

  let(:trigger) { create(:trigger) }

  let(:resolved_scope) { TriggerPolicy::Scope.new(account, Trigger.all).resolve }

  context "being a visitor" do
    let(:account) { nil }

    it { should forbid_new_and_create_actions }
    it { should forbid_edit_and_update_actions }
  end

  context "having an account" do
    context "account is on a different organization" do
      let(:account) { create(:account) }

      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }

      it 'excludes trigger in resolved scope' do
        expect(resolved_scope).not_to include(trigger)
      end
    end

    context "account is on the same organization as the trigger" do
      let(:user) { create(:user, organization: trigger.organization) }
      let(:account) { create(:account, user: user) }

      it { should permit_new_and_create_actions }
      it { should permit_edit_and_update_actions }
      it { should permit_mass_assignment_of(:status) }
      it { should permit_mass_assignment_of(:observable_type) }
      it { should permit_mass_assignment_of(:observable_id) }
      it { should permit_mass_assignment_of(:event) }

      it 'includes trigger in resolved scope' do
        expect(resolved_scope).to include(trigger)
      end
    end
  end
end
