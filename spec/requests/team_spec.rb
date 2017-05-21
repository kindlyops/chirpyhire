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
        account.memberships.each { |m| m.update(role: :member) }
      end

      it 'lets the user edit the name' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { team.reload.name }.to(name)
      end

      it 'lets the user edit the description' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { team.reload.description }.to(description)
      end

      it 'lets the user edit the recruiter' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { team.reload.recruiter }.to(team_member)
      end
    end

    context 'as a team manager' do
      before do
        account.memberships.each { |m| m.update(role: :manager) }
      end

      it 'lets the user edit the name' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { team.reload.name }.to(name)
      end

      it 'lets the user edit the description' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { team.reload.description }.to(description)
      end

      it 'lets the user edit the recruiter' do
        expect {
          put organization_team_path(organization, team), params: params
        }.to change { team.reload.recruiter }.to(team_member)
      end
    end

    context 'not on the team' do
      before do
        team.memberships.destroy_all
      end

      it 'does not let the user edit the name' do
        expect {
          put organization_team_path(organization, team), params: params
        }.not_to change { team.reload.name }
      end

      it 'does not let the user edit the description' do
        expect {
          put organization_team_path(organization, team), params: params
        }.not_to change { team.reload.description }
      end

      it 'does not let the user edit the recruiter' do
        expect {
          put organization_team_path(organization, team), params: params
        }.not_to change { team.reload.recruiter }
      end
    end
  end

  describe 'viewing teams' do
    context 'as an organization owner' do
      before do
        account.update(role: :owner)
      end

      it 'does not show the "Create team" button' do
        get organization_teams_path(organization)
        expect(response.body).to include('Create team')
      end
    end

    context 'as an organization member' do
      before do
        account.update(role: :member)
      end

      it 'does not show the "Create team" button' do
        get organization_teams_path(organization)
        expect(response.body).not_to include('Create team')
      end
    end

    context 'as a member' do
      before do
        account.memberships.each { |m| m.update(role: :member) }
      end

      it 'does not say "Manage"' do
        get organization_teams_path(organization)
        expect(response.body).not_to include('Manage')
      end
    end

    context 'as a team manager' do
      before do
        account.memberships.each { |m| m.update(role: :manager) }
      end

      it 'says "Manage"' do
        get organization_teams_path(organization)
        expect(response.body).to include('Manage')
      end
    end
  end

  describe 'creating a new team' do
    let(:name) { Faker::Name.name }

    before do
      allow(PhoneNumberProvisioner).to receive(:provision) do |team|
        phone = Faker::PhoneNumber.cell_phone
        team.update(phone_number: phone)
      end
    end

    let(:params) {
      {
        team: {
          name: name,
          location_attributes: {
            latitude: 10.0,
            longitude: 11.2,
            full_street_address: '1000 Main St. Atlanta, GA, 30308',
            postal_code: '30308',
            state: 'Georgia',
            state_code: 'GA',
            country: 'United States',
            country_code: 'US',
            city: 'Atlanta'
          }
        }
      }
    }

    context 'as an owner' do
      before do
        account.update(role: :owner)
      end

      it 'creates a team' do
        expect {
          post organization_teams_path(organization), params: params
        }.to change { organization.reload.teams.count }
      end

      it 'sets the phone number on the team' do
        post organization_teams_path(organization), params: params
        expect(Team.last.phone_number.present?).to eq(true)
      end

      it 'creates a recruiting ad' do
        expect {
          post organization_teams_path(organization), params: params
        }.to change { organization.reload.recruiting_ads.count }
      end

      it 'creates a location' do
        expect {
          post organization_teams_path(organization), params: params
        }.to change { organization.reload.locations.count }
      end

      it 'adds the creator to the team' do
        post organization_teams_path(organization), params: params
        expect(Team.last.accounts).to include(account)
      end

      it 'adds the creator to the team as a manager' do
        post organization_teams_path(organization), params: params
        expect(account.manages?(Team.last)).to eq(true)
      end

      it 'sets the creator as the recruiter' do
        post organization_teams_path(organization), params: params
        expect(Team.last.recruiter).to eq(account)
      end
    end

    context 'as a member' do
      before do
        account.update(role: :member)
      end

      it 'does not create a team' do
        expect {
          post organization_teams_path(organization), params: params
        }.not_to change { organization.reload.teams.count }
      end
    end
  end
end
