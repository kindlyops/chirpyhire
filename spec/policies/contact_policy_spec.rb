require 'rails_helper'

RSpec.describe ContactPolicy do
  describe 'scope' do
    subject { ContactPolicy::Scope.new(account, Contact.all) }

    context 'teams' do
      let(:team) { create(:team, :account) }
      let(:account) { team.accounts.first }
      let(:other_team) { create(:team, organization: team.organization) }
      let!(:contact) { create(:contact, team: other_team) }

      context 'account is on a different team than the contact' do
        it 'does include the contact' do
          expect(subject.resolve).to include(contact)
        end
      end

      context 'account is on same team as the contact' do
        let(:team) { create(:team, :account) }
        let(:account) { team.accounts.first }
        let!(:contact) { create(:contact, organization: organization) }

        it 'does include the contact' do
          expect(subject.resolve).to include(contact)
        end
      end
    end

    context 'when account id is different from organization id' do
      let(:first_account) { create(:account) }
      let!(:other_account) { create(:account, organization: first_account.organization) }
      let!(:account) { create(:account, :team) }
      let(:team) { account.teams.first }

      context 'and the organization has contacts' do
        before do
          create_list(:contact, 3, team: team)
        end

        it 'is the 3 contacts' do
          expect(subject.resolve.count).to eq(3)
        end
      end
    end
  end
end
