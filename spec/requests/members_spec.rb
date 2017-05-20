require 'rails_helper'

RSpec.describe 'Team Members' do
  let(:account) { create(:account, :team) }
  let(:organization) { account.organization }
  let(:team_member) { create(:account, organization: organization) }
  let(:team) { account.teams.first }

  before do
    team.accounts << team_member
    sign_in(account)
  end

  describe 'viewing team members' do
    context 'as a member' do
      before do
        account.memberships.each { |m| m.update(role: :member) }
      end

      it 'does not include the Add a member button' do
        get organization_team_members_path(organization, team)
        expect(response.body).not_to include('Add a member')
      end

      it 'does not include the remove from team button' do
        get organization_team_members_path(organization, team)
        expect(response.body).not_to include('Remove from team')
      end

      it 'does not include the role dropdown button' do
        get organization_team_members_path(organization, team)
        expect(response.body).not_to include('Can add and remove users')
      end
    end

    context 'as a non member' do
      before do
        account.memberships.each(&:destroy)
      end

      it 'does not include the Add a member button' do
        get organization_team_members_path(organization, team)
        expect(response.body).not_to include('Add a member')
      end

      it 'does not include the remove from team button' do
        get organization_team_members_path(organization, team)
        expect(response.body).not_to include('Remove from team')
      end

      it 'does not include the role dropdown button' do
        get organization_team_members_path(organization, team)
        expect(response.body).not_to include('Can add and remove users')
      end
    end

    context 'as a manager' do
      before do
        account.memberships.each { |m| m.update(role: :manager) }
      end

      it 'includes the Add a member button' do
        get organization_team_members_path(organization, team)
        expect(response.body).to include('Add a member')
      end

      it 'includes the remove from team button' do
        get organization_team_members_path(organization, team)
        expect(response.body).to include('Remove from team')
      end

      it 'includes the role dropdown button' do
        get organization_team_members_path(organization, team)
        expect(response.body).to include('Can add and remove users')
      end
    end
  end
end
