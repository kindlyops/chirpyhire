require 'rails_helper'

RSpec.describe UserPolicy do
  subject { UserPolicy.new(account, user) }

  let!(:user) { create(:user) }

  let(:resolved_scope) { UserPolicy::Scope.new(account, User.all).resolve }

  context "being a visitor" do
    let(:account) { nil }

    it "raises a NotAuthorizedError" do
      expect {
        subject
      }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  context "having an account" do
    context "account is on a different organization" do
      let(:account) { create(:account) }

      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:show) }

      it 'excludes user in resolved scope' do
        expect(resolved_scope).not_to include(user)
      end
    end

    context "account is on the same organization as the user" do
      let(:account_user) { create(:user, organization: user.organization) }
      let(:account) { create(:account, user: account_user) }

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
