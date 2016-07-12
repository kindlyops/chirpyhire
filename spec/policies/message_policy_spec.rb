require 'rails_helper'

RSpec.describe MessagePolicy do
  subject { MessagePolicy.new(account, message) }

  let(:message) { create(:message) }

  let(:resolved_scope) { MessagePolicy::Scope.new(account, Message.all).resolve }

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
    let(:recipient) { message.user }

    context "account is on a different organization" do
      it 'excludes message in resolved scope' do
        expect(resolved_scope).not_to include(message)
      end

      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:show) }
    end

    context "account is on the same organization as the message" do
      let(:user) { create(:user, organization: recipient.organization) }
      let(:account) { create(:account, user: user) }

      it 'includes message in resolved scope' do
        expect(resolved_scope).to include(message)
      end

      it { should permit_mass_assignment_of(:body) }
      it { should permit_new_and_create_actions }
    end
  end
end
