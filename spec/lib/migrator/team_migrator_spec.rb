require 'rails_helper'

RSpec.describe Migrator::TeamMigrator do
  let(:to_organization) { create(:organization) }
  let(:from_organization) { create(:organization, :team_with_phone_number_and_recruiting_ad) }
  let(:team) { from_organization.teams.first }
  let!(:phone_number) { team.phone_number }

  let(:from_account_a) { create(:account, organization: from_organization) }
  let(:from_account_b) { create(:account, organization: from_organization) }
  let(:from_account_c) { create(:account, organization: from_organization) }

  let(:to_account_a) { create(:account, organization: to_organization) }
  let(:to_account_b) { create(:account, organization: to_organization) }
  let(:to_account_c) { create(:account, organization: to_organization) }

  let(:organizations) do
    { from: from_organization, to: to_organization }
  end

  let(:accounts) do
    [
      { from: from_account_a, to: to_account_a },
      { from: from_account_b, to: to_account_b },
      { from: from_account_c, to: to_account_c }
    ]
  end

  let!(:options) do
    {
      organizations: organizations,
      accounts: accounts,
      team: team
    }
  end

  subject { Migrator::TeamMigrator.new(options) }

  describe '#migrate' do
    it 'updates the old team phone number' do
      subject.migrate
      expect(team.phone_number).to eq("MIGRATED:#{phone_number}")
    end

    it 'creates a new team' do
      expect {
        subject.migrate
      }.to change { Team.count }.by(1)
      expect(Team.last.name).to eq(team.name)
      expect(Team.last.phone_number).to eq(phone_number)
      expect(Team.last.organization).to eq(to_organization)
    end

    it 'creates a new recruiting ad' do
      expect {
        subject.migrate
      }.to change { RecruitingAd.count }.by(1)
      expect(RecruitingAd.last.body).to eq(team.recruiting_ad.body)
      expect(RecruitingAd.last.organization).to eq(to_organization)
    end

    it 'joins the accounts to the new team' do
      subject.migrate

      accounts.map { |a| a[:to] }.each do |account|
        expect(Team.last.accounts).to include(account)
      end
    end  
  end
end
