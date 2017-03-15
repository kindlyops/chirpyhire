require 'rails_helper'

RSpec.describe ContactPolicy do
  describe 'scope' do
    subject { ContactPolicy::Scope.new(account, Contact.all) }

    context 'when account id is different from organization id' do
      let(:first_account) { create(:account) }
      let!(:other_account) { create(:account, organization: first_account.organization) }
      let!(:account) { create(:account) }

      context 'and the organization has contacts' do
        before do
          create_list(:contact, 3, organization: account.organization)
        end

        it 'is the 3 contacts' do
          expect(subject.resolve.count).to eq(3)
        end
      end
    end
  end
end
