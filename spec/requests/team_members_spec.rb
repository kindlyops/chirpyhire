require 'rails_helper'

RSpec.describe 'Team Members' do
  let!(:organization) { create(:organization, :account) }
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
            put organization_person_path(organization, team_member), params: params
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
            put organization_person_path(organization, team_member), params: params
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
            put organization_person_path(organization, team_member), params: params
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
            put organization_person_path(organization, team_member), params: params
          }.to change { team_member.reload.owner? }.from(true).to(false)
        end
      end
    end
  end
end
