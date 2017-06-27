require 'rails_helper'

RSpec.describe 'Account' do
  let(:organization) { create(:organization, :account) }
  let(:account) { organization.accounts.first }

  before do
    sign_in(account)
  end

  context 'other accounts' do
    let(:team_member) { create(:account, organization: organization) }

    let(:params) {
      {
        account: {
          id: team_member.id,
          role: role
        }
      }
    }

    context 'as member' do
      before do
        account.update(role: :member)
      end

      context 'team member member' do
        let(:role) { :owner }
        before do
          team_member.update(role: :member)
        end

        it 'does not allow you to promote a member to an owner' do
          expect {
            put account_path(team_member), params: params
          }.not_to change { team_member.reload.owner? }
        end
      end

      context 'team member owner' do
        let(:role) { :member }

        before do
          team_member.update(role: :owner)
        end

        it 'does not allow you to demote an owner to a member' do
          expect {
            put account_path(team_member), params: params
          }.not_to change { team_member.reload.owner? }
        end
      end
    end

    context 'as owner' do
      before do
        account.update(role: :owner)
      end

      context 'team member member' do
        let(:role) { :owner }
        before do
          team_member.update(role: :member)
        end

        it 'allows you to promote a member to an owner' do
          expect {
            put account_path(team_member), params: params
          }.to change { team_member.reload.owner? }.from(false).to(true)
        end
      end

      context 'team member owner' do
        let(:role) { :member }

        before do
          team_member.update(role: :owner)
        end

        it 'allows you to demote an owner to a member' do
          expect {
            put account_path(team_member), params: params
          }.to change { team_member.reload.owner? }.from(true).to(false)
        end
      end
    end
  end

  context 'your own profile' do
    describe 'editing your profile' do
      let!(:name) { Faker::Name.name }
      let(:email) { Faker::Internet.email }

      let!(:params) {
        {
          account: {
            email: email,
            person_attributes: {
              name: name
            }
          }
        }
      }

      it 'lets the user edit their name' do
        expect {
          put account_path(account), params: params
        }.to change { account.reload.name }.to(name)
      end

      it 'lets the user edit their email' do
        expect {
          put account_path(account), params: params
        }.to change { account.reload.email }.to(email)
      end
    end

    describe 'changing your password' do
      let(:current_password) { '$3cret$$' }
      let(:new_password) { 'password' }

      let(:params) do
        {
          account_id: account.id,
          account: {
            current_password: current_password,
            password: new_password,
            password_confirmation: new_password
          }
        }
      end

      before do
        account.update(password: current_password)
      end

      it 'lets you change your password' do
        expect {
          put account_settings_password_path(account), params: params
        }.to change { account.reload.encrypted_password }
      end
    end
  end
end
