require 'rails_helper'

RSpec.describe ContactPolicy do
  describe 'scope' do
    subject { ContactPolicy::Scope.new(account, Contact.all) }

    context 'organizations' do
      let(:organization) { create(:organization, :subscription, :account) }
      let(:account) { organization.accounts.first }
      let(:other_organization) { create(:organization) }
      let!(:contact) { create(:contact, organization: other_organization) }

      context 'account is on a different organization than the contact' do
        it 'does not include the contact' do
          expect(subject.resolve).not_to include(contact)
        end
      end

      context 'account is on same organization as the contact' do
        let(:organization) { create(:organization, :subscription, :account) }
        let(:account) { organization.accounts.first }
        let!(:contact) { create(:contact, organization: organization) }

        it 'does include the contact' do
          expect(subject.resolve).to include(contact)
        end

        context 'organization is canceled' do
          before do
            organization.subscription.update(
              internal_status: :canceled, internal_canceled_at: 1.year.ago
            )
          end

          context 'and contact is created after canceled at' do
            it 'does not include the contact' do
              expect(subject.resolve).not_to include(contact)
            end
          end
        end
      end
    end

    context 'when account id is different from organization id' do
      let(:first_account) { create(:account) }
      let!(:other_account) { create(:account, organization: first_account.organization) }
      let!(:account) { create(:account) }
      let(:organization) { account.organization }

      context 'and the organization has contacts' do
        before do
          create_list(:contact, 3, organization: organization)
        end

        it 'is the 3 contacts' do
          expect(subject.resolve.count).to eq(3)
        end
      end
    end
  end
end
