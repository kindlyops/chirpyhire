require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class.new(organization, user) }

  let!(:user) { create(:user) }

  let(:resolved_scope) { UserPolicy::Scope.new(organization, User.all).resolve }

  context 'being a visitor' do
    let(:organization) { nil }

    it 'raises a NotAuthorizedError' do
      expect do
        subject
      end.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  context 'having an organization' do
    context 'user does not belong to the organization' do
      let(:organization) { create(:organization) }

      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:show) }

      it 'excludes user in resolved scope' do
        expect(resolved_scope).not_to include(user)
      end
    end

    context 'user belongs to organization' do
      let(:organization) { user.organization }

      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should permit_action(:show) }

      it 'includes user in resolved scope' do
        expect(resolved_scope).to include(user)
      end
    end
  end
end
