require 'rails_helper'

RSpec.describe Maintenance::OrganizationRemover do
  let(:organization) { create(:organization, :with_subscription, :with_survey, :with_account, :with_location, twilio_account_sid: 'DUMMY') }
  context 'with an organization' do
    before(:each) do
      organization.update!(phone_number: Faker::PhoneNumber.cell_phone)
    end
    describe '#delete_organization' do
      it 'checks for confirmation' do
        expect {
          Maintenance::OrganizationRemover.new(organization).delete_organization
        }.to raise_error(StandardError)
      end
      it 'deletes the organization' do
        Maintenance::OrganizationRemover.new(organization).delete_organization(confirmed: true)
        expect(Organization.find_by(id: organization.id)).to eq(nil)
      end
    end

    describe '#close_organization' do
      it 'checks for confirmation' do
        expect {
          Maintenance::OrganizationRemover.new(organization).close_organization
        }.to raise_error(StandardError)
      end
      it 'does not delete the organization' do
        Maintenance::OrganizationRemover.new(organization).close_organization(confirmed: true)
        expect(organization).not_to eq(nil)
      end
      it 'closes the account' do
        Maintenance::OrganizationRemover.new(organization).close_organization(confirmed: true)
        expect(organization.subscription.state).to eq('canceled')
      end
    end
  end
end
