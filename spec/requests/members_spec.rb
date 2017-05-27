require 'rails_helper'

RSpec.describe 'Team Members' do
  let(:account) { create(:account, :inbox, :team_with_phone_number) }
  let(:organization) { account.organization }
  let(:team_member) { create(:account, :inbox, organization: organization) }
  let(:team) { account.teams.first }

  before do
    sign_in(account)
  end

  context 'removing a team member' do
    before do
      team.accounts << team_member
    end

    let(:member) { team_member.memberships.find_by(team: team) }

    describe 'as a manager' do
      before do
        account.memberships.each { |m| m.update(role: :manager) }
      end

      it 'removes the team member from the team' do
        expect {
          delete organization_team_member_path(organization, team, member)
        }.to change { team.accounts.count }.by(-1)
      end
    end

    describe 'as a member' do
      before do
        account.memberships.each { |m| m.update(role: :member) }
      end

      it 'does not remove the team member from the team' do
        expect {
          delete organization_team_member_path(organization, team, member)
        }.not_to change { team.accounts.count }
      end
    end
  end

  context 'adding a team member' do
    let(:params) do
      {
        membership: {
          account_id: team_member.id
        }
      }
    end

    describe 'as a manager' do
      before do
        account.memberships.each { |m| m.update(role: :manager) }
      end

      it 'notifies the new team member' do
        expect(TeamMemberNotifier).to receive(:call)
        post organization_team_members_path(organization, team), params: params
      end

      it 'adds the team member from the team' do
        allow(TeamMemberNotifier).to receive(:call)

        expect {
          post organization_team_members_path(organization, team), params: params
        }.to change { team.accounts.count }.by(1)
      end
    end

    describe 'as a member' do
      before do
        account.memberships.each { |m| m.update(role: :member) }
      end

      it 'does not add the team member from the team' do
        expect {
          post organization_team_members_path(organization, team), params: params
        }.not_to change { team.accounts.count }
      end
    end
  end

  context 'changing role of a team member' do
    before do
      team.accounts << team_member
    end

    let(:member) { team_member.memberships.find_by(team: team) }
    let(:params) do
      {
        membership: {
          role: :manager
        }
      }
    end

    describe 'as a manager' do
      before do
        account.memberships.each { |m| m.update(role: :manager) }
      end

      it 'changes the role on the member' do
        expect {
          put organization_team_member_path(organization, team, member), params: params
        }.to change { member.reload.role }.from('member').to('manager')
      end
    end

    describe 'as a member' do
      before do
        account.memberships.each { |m| m.update(role: :member) }
      end

      it 'does not change the role on the member' do
        expect {
          put organization_team_member_path(organization, team, member), params: params
        }.not_to change { member.reload.role }
      end
    end

    describe 'as a non member' do
      before do
        account.memberships.each(&:destroy)
      end

      it 'does not change the role on the member' do
        expect {
          put organization_team_member_path(organization, team, member), params: params
        }.not_to change { member.reload.role }
      end
    end
  end

  describe 'viewing team members' do
    before do
      team.accounts << team_member
    end

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
