require 'rails_helper'

RSpec.describe ActivityPolicy do
  subject { ActivityPolicy.new(account, activity) }

  let(:notification) { create(:notification) }
  let(:activity) { notification.activities.last }

  let(:resolved_scope) { ActivityPolicy::Scope.new(account, Activity.all).resolve }

  context "having an account" do
    let(:account) { create(:account) }
    context "account is on a different organization" do
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:show) }

      it 'excludes activity in resolved scope' do
        expect(resolved_scope).not_to include(activity)
      end
    end

    context "account is on the same organization as the activity" do
      let(:user) { create(:user, organization: activity.organization) }
      let(:account) { create(:account, user: user) }

      it { should permit_action(:update) }
      it { should forbid_new_and_create_actions }
      it { should forbid_action(:edit) }
      it { should forbid_action(:destroy) }
      it { should permit_action(:show) }
      it { should permit_mass_assignment_of(:outstanding) }

      it 'includes activity in resolved scope' do
        expect(resolved_scope).to include(activity)
      end
    end
  end
end
