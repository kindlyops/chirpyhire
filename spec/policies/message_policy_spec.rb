require 'rails_helper'

RSpec.describe MessagePolicy do
  subject { MessagePolicy.new(organization, message) }

  let(:message) { create(:message) }

  let(:resolved_scope) { MessagePolicy::Scope.new(organization, Message.all).resolve }

  context 'being a visitor' do
    let(:organization) { nil }

    it 'raises a NotAuthorizedError' do
      expect do
        subject
      end.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  context 'having an organization' do
    let(:organization) { create(:organization) }
    let(:recipient) { message.user }

    context 'message does not belong to the organization' do
      it 'excludes message in resolved scope' do
        expect(resolved_scope).not_to include(message)
      end

      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:show) }
    end

    context 'message belongs to the organization' do
      let(:organization) { message.organization }

      it 'includes message in resolved scope' do
        expect(resolved_scope).to include(message)
      end

      it { should permit_mass_assignment_of(:body) }
      it { should forbid_new_and_create_actions }

      context 'recipient is subscribed' do
        before(:each) do
          message.user.update(subscribed: true)
        end

        it { should permit_new_and_create_actions }
      end
    end
  end
end
