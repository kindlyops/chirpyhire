require 'rails_helper'

RSpec.describe 'Team' do
  let(:account) { create(:account, :team_with_phone_number_and_inbox) }
  let(:organization) { account.organization }
  let(:team_member) { create(:account, organization: organization) }
  let(:team) { account.teams.first }

  before do
    team.accounts << team_member
    sign_in(account)
  end

  describe 'viewing teams' do
    it 'does show the "Create team" button' do
      get organization_settings_teams_path(organization)
      expect(response.body).to include('Create team')
    end
  end

  describe 'creating a new team' do
    let(:name) { Faker::Name.name }

    before do
      allow(PhoneNumberProvisioner).to receive(:provision) do |team|
        organization = team.organization
        phone_number = organization.phone_numbers.create(
          sid: Faker::Number.number(10),
          phone_number: Faker::PhoneNumber.cell_phone
        )
        organization.assignment_rules.create(
          phone_number: phone_number, inbox: team.inbox
        )
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

    it 'sets the creator as the recruiter' do
      post organization_teams_path(organization), params: params
      expect(Team.last.recruiter).to eq(account)
    end
  end
end
