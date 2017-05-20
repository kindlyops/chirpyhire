require 'rails_helper'

RSpec.describe 'People' do
  let(:organization) { create(:organization, :account) }
  let(:account) { organization.accounts.first }

  before do
    sign_in(account)
  end

  describe 'viewing a person' do
    let!(:team_member) { create(:account, organization: organization) }

    context 'as an owner' do
      before do
        account.update(role: :owner)
      end

      it 'has a button to change the account role' do
        get organization_person_path(organization, team_member)
        expect(response.body).to include('full administrative access')
      end
    end

    context 'as a member' do
      it 'does not have a button to change the account role' do
        get organization_person_path(organization, team_member)
        expect(response.body).not_to include('full administrative access')
      end
    end
  end

  describe 'viewing people' do
    context 'as a member' do
      before do
        account.update(role: :member)
      end

      it 'does not say "Manage"' do
        get organization_people_path(organization)
        expect(response.body).not_to include('Manage')
      end
    end

    context 'as a owner' do
      before do
        account.update(role: :owner)
      end

      it 'says "Manage"' do
        get organization_people_path(organization)
        expect(response.body).to include('Manage')
      end
    end
  end
end
