require 'rails_helper'

RSpec.describe 'Registration' do
  describe 'sign up' do
    let(:organization_name) { 'Orn, Beer and Schaden' }
    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }
    context 'with valid credentials' do
      let(:password) { Faker::Internet.password }

      before do
        allow(PhoneNumberProvisioner).to receive(:provision) do |organization|
          organization.update(phone_number: Faker::PhoneNumber.cell_phone)
        end
      end

      let(:params) {
        {
          account: {
            person_attributes: {
              name: name
            },
            email: email,
            agreed_to_terms: true,
            password: password,
            organization_attributes: {
              name: organization_name,
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
      }

      it 'progress to recruiting ad' do
        post account_registration_path, params: params
        expect(response).to redirect_to recruiting_ad_path
        expect(Account.last.email).to eq(email)
        expect(Account.last.name).to eq(name)
        expect(Account.last.inbox.present?).to eq(true)
        expect(Organization.last.name).to eq(organization_name)
      end
    end
  end
end
