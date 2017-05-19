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
    end

    it 'has the old team phone number' do
      subject.migrate
      expect(Team.last.phone_number).to eq(phone_number)
    end

    it 'is tied to the new organization' do
      subject.migrate
      expect(Team.last.organization).to eq(to_organization)
    end

    it 'has the old team name' do
      subject.migrate
      expect(Team.last.name).to eq(team.name)
    end

    it 'creates a new recruiting ad' do
      expect {
        subject.migrate
      }.to change { RecruitingAd.count }.by(1)
    end

    it 'has the old ad body' do
      subject.migrate
      expect(RecruitingAd.last.body).to eq(team.recruiting_ad.body)
    end

    it 'is tied to the new organization' do
      subject.migrate
      expect(RecruitingAd.last.organization).to eq(to_organization)
    end

    it 'joins the accounts to the new team' do
      subject.migrate

      accounts.map { |a| a[:to] }.each do |account|
        expect(Team.last.accounts).to include(account)
      end
    end

    context 'with contact' do
      let!(:contact) { create(:contact, team: team) }

      context 'with conversations' do
        before do
          IceBreaker.call(contact)
        end

        it 'creates a new contact' do
          expect {
            subject.migrate
          }.to change { Contact.count }.by(1)
        end

        it 'is tied to the old person' do
          subject.migrate
          expect(Contact.last.person).to eq(contact.person)
        end

        it 'is tied to the new team' do
          subject.migrate
          expect(Contact.last.team).to eq(Team.last)
        end

        context 'with read receipts' do

        end
      end

      context 'with notes' do

      end
    end
  end
end
