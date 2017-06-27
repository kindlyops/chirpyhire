require 'rails_helper'

RSpec.describe 'Team Members' do
  let(:account) { create(:account, :team_with_phone_number_and_inbox) }
  let(:organization) { account.organization }
  let(:team_member) { create(:account, organization: organization) }
  let(:team) { account.teams.first }

  before do
    sign_in(account)
  end

  context 'removing a team member' do
    before do
      team.accounts << team_member
    end

    let(:member) { team_member.memberships.find_by(team: team) }

    it 'removes the team member from the team' do
      expect {
        delete organization_team_member_path(organization, team, member)
      }.to change { team.accounts.count }.by(-1)
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
end
