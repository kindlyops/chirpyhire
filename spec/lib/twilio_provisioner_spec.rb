require 'rails_helper'

RSpec.describe TwilioProvisioner do
  let(:organization) { create(:organization, :with_subscription, twilio_account_sid: nil, twilio_auth_token: nil, phone_number: nil) }
  let!(:location) { create(:location, organization: organization, latitude: 37.870842, longitude: -122.501366, state: 'CA') }

  describe '#close_account' do
    context 'when the organization does not have a number' do
      it 'does nothing' do
        expect {
          TwilioProvisioner.new(organization).close_account
        }.not_to change(organization, :subscription)
      end
    end
    context 'when the organization has a phone number' do
      it 'it closes the account' do
        expect {
          organization.update!(phone_number: Faker::PhoneNumber.cell_phone, twilio_account_sid: 'DUMMY')
          TwilioProvisioner.new(organization).close_account
        }.to change { organization.subscription.state }.to('canceled')
      end
    end
  end

  describe '#provision' do
    context 'when the organization has a phone number' do
      before(:each) do
        organization.update(phone_number: Faker::PhoneNumber.cell_phone)
      end

      it 'does not update the organization' do
        expect {
          TwilioProvisioner.new(organization).provision
        }.not_to change { organization.phone_number }
      end
    end

    context 'when the organization does not have a phone number', vcr: { cassette_name: 'TwilioProvisioner-call' } do
      it 'creates a twilio subaccount' do
        expect {
          expect {
            TwilioProvisioner.new(organization).provision
          }.to change { organization.twilio_account_sid.present? }.from(false).to(true)
        }.to change { organization.twilio_auth_token.present? }.from(false).to(true)
      end

      it 'creates a phone number for the organization' do
        expect {
          TwilioProvisioner.new(organization).provision
        }.to change { organization.phone_number.present? }.from(false).to(true)
      end
    end
  end
end
