require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { create(:account) }
  let(:invite_params) do
    { email: 'bob@example.com',
      user_attributes: {
        organization: account.organization
      } }
  end

  describe '.accept_invitation!' do
    context 'with an invitable account with a user' do
      let(:invitable) do
        Account.invite!(invite_params, account)
      end

      context 'with user attributes passed' do
        let(:invitation_attributes) do
          {
            invitation_token: invitable.raw_invitation_token,
            password: 'password',
            password_confirmation: 'password',
            user_attributes: {
              first_name: 'Bob',
              last_name: 'Bobson'
            }
          }
        end

        it "does not override the user's organization" do
          expect do
            Account.accept_invitation!(invitation_attributes)
          end.not_to change { invitable.reload.user.organization.present? }
        end
      end
    end
  end

  describe '#send_reset_password_instructions' do
    context 'with an invitation token' do
      let(:account) { create(:account, invitation_token: '123') }
      it 'does not send a password reset email' do
        expect do
          account.send_reset_password_instructions
        end.not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end
end
