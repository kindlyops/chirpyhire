require 'rails_helper'

RSpec.describe TaskPolicy do
  subject { TaskPolicy.new(account, task) }

  let(:task) { create(:task) }

  let(:resolved_scope) { TaskPolicy::Scope.new(account, Task.all).resolve }

  context "having an account" do
    let(:account) { create(:account) }
    context "account is on a different organization" do
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:show) }

      it 'excludes task in resolved scope' do
        expect(resolved_scope).not_to include(task)
      end
    end

    context "account is on the same organization as the task" do
      let(:user) { create(:user, organization: task.organization) }
      let(:account) { create(:account, user: user) }

      it { should permit_action(:update) }
      it { should forbid_new_and_create_actions }
      it { should forbid_action(:edit) }
      it { should forbid_action(:destroy) }
      it { should permit_action(:show) }
      it { should permit_mass_assignment_of(:outstanding) }
      it { should forbid_mass_assignment_of(:message_id) }

      it 'includes task in resolved scope' do
        expect(resolved_scope).to include(task)
      end
    end
  end
end
