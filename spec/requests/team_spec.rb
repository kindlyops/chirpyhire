require 'rails_helper'

RSpec.describe 'Team' do
  let(:account) { create(:account, :team) }
  let(:organization) { account.organization }
  let(:team_member) { create(:account, organization: organization) }
  let(:team) { account.teams.first }

  before do
    team.accounts << team_member
    sign_in(account)
  end

  describe 'editing a team' do
    let(:name) { Faker::Name.name }
    let(:description) { Faker::Lorem.sentence }
    let(:recruiter_id) { team_member.id }

    let(:params) {
      {
        organization_id: organization.id,
        id: team.id,
        team: {
          name: name,
          description: description,
          recruiter_id: recruiter_id
        }
      }
    }

    context 'as a team member' do
      before do
        account.memberships.update_all(role: :member)
      end

      it 'lets the user edit the name' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { organization.reload.name }.to(name)
      end

      it 'lets the user edit the email' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { organization.reload.email }.to(email)
      end

      it 'lets the user edit the description' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { organization.reload.description }.to(description)
      end

      it 'lets the user edit the url' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { organization.reload.url }.to(url)
      end

      it 'does not let the user edit the billing_email' do
        expect {
          put organization_team_path(organization, team), params: params
        }.not_to change { organization.reload.billing_email }
      end
    end

    context 'as a team manager' do
      before do
        account.memberships.update_all(role: :manager)
      end

      it 'lets the user edit the name' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { organization.reload.name }.to(name)
      end

      it 'lets the user edit the email' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { organization.reload.email }.to(email)
      end

      it 'lets the user edit the description' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { organization.reload.description }.to(description)
      end

      it 'lets the user edit the url' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { organization.reload.url }.to(url)
      end

      it 'lets the user edit the billing_email' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { organization.reload.billing_email }.to(billing_email)
      end
    end
  end

  # describe 'viewing teams' do
  #   before do
  #     create(:team, organization: organization)
  #   end
    
  #   context 'as a member' do
  #     before do
  #       account.update(role: :member)
  #     end

  #     it 'does not say "Manage"' do
  #       get organization_teams_path(organization)
  #       expect(response.body).not_to include('Manage')
  #     end
  #   end

  #   context 'as a owner' do
  #     before do
  #       account.update(role: :owner)
  #     end

  #     it 'says "Manage"' do
  #       get organization_teams_path(organization)
  #       expect(response.body).to include('Manage')
  #     end
  #   end
  # end
end
