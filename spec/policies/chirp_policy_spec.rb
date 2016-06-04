require 'rails_helper'

RSpec.describe ChirpPolicy do
  subject { ChirpPolicy.new(account, chirp) }

  let(:chirp) { create(:chirp, :with_message) }

  let(:resolved_scope) { ChirpPolicy::Scope.new(account, Chirp.all).resolve }

  context "being a visitor" do
    let(:account) { nil }

    it "raises a NotAuthorizedError" do
      expect {
        subject
      }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  context "having an account" do
    let(:account) { create(:account) }
    let(:recipient) { chirp.user }

    context "account is on a different organization" do
      it 'excludes chirp in resolved scope' do
        expect(resolved_scope).not_to include(chirp)
      end

      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:show) }
    end

    context "account is on the same organization as the chirp" do
      let(:user) { create(:user, organization: recipient.organization) }
      let(:account) { create(:account, user: user) }

      it 'includes chirp in resolved scope' do
        expect(resolved_scope).to include(chirp)
      end

      it { should permit_mass_assignment_of(:user_id) }
      it { should permit_new_and_create_actions }
    end
  end
end
