require 'rails_helper'

RSpec.describe 'Organization' do
  let(:organization) { create(:organization, :account, :team) }
  let(:account) { organization.accounts.first }

  before do
    sign_in(account)
  end

  describe 'editing your organization' do
    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }
    let(:description) { Faker::Lorem.sentence }
    let(:url) { Faker::Internet.url }
    let(:billing_email) { Faker::Internet.email }

    let(:params) {
      {
        organization: {
          email: email,
          name: name,
          description: description,
          url: url,
          billing_email: billing_email
        }
      }
    }

    context 'member' do
      before do
        account.update(role: :member)
      end

      it 'lets the user edit the name' do
        expect {
          put organization_path(organization), params: params
        }.to change { organization.reload.name }.to(name)
      end

      it 'lets the user edit the email' do
        expect {
          put organization_path(organization), params: params
        }.to change { organization.reload.email }.to(email)
      end

      it 'lets the user edit the description' do
        expect {
          put organization_path(organization), params: params
        }.to change { organization.reload.description }.to(description)
      end

      it 'lets the user edit the url' do
        expect {
          put organization_path(organization), params: params
        }.to change { organization.reload.url }.to(url)
      end

      it 'does not let the user edit the billing_email' do
        expect {
          put organization_path(organization), params: params
        }.not_to change { organization.reload.billing_email }
      end
    end

    context 'owner' do
      before do
        account.update(role: :owner)
      end

      it 'lets the user edit the name' do
        expect {
          put organization_path(organization), params: params
        }.to change { organization.reload.name }.to(name)
      end

      it 'lets the user edit the email' do
        expect {
          put organization_path(organization), params: params
        }.to change { organization.reload.email }.to(email)
      end

      it 'lets the user edit the description' do
        expect {
          put organization_path(organization), params: params
        }.to change { organization.reload.description }.to(description)
      end

      it 'lets the user edit the url' do
        expect {
          put organization_path(organization), params: params
        }.to change { organization.reload.url }.to(url)
      end

      it 'lets the user edit the billing_email' do
        expect {
          put organization_path(organization), params: params
        }.to change { organization.reload.billing_email }.to(billing_email)
      end
    end
  end

  describe 'viewing people' do
    context 'as a member' do
      before do
        account.update(role: :member)
      end

      it 'does not say "Role"' do
        get organization_settings_team_members_path(organization)
        expect(response.body).not_to include('Role')
      end
    end

    context 'as a owner' do
      before do
        account.update(role: :owner)
      end

      it 'says "Role"' do
        get organization_settings_team_members_path(organization)
        expect(response.body).to include('Role')
      end
    end
  end
end
