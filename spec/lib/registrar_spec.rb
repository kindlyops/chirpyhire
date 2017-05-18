require 'rails_helper'

RSpec.describe Registrar do
  describe 'register' do
    subject { Registrar.new(account) }
    let(:organization) { create(:organization, :team) }

    before do
      allow(PhoneNumberProvisioner).to receive(:provision) do |team, organization|
        phone = Faker::PhoneNumber.cell_phone
        organization.update(phone_number: phone)
        team.update(phone_number: phone)
      end
    end

    context 'account not persisted' do
      let!(:account) { build(:account, organization: organization) }

      it 'does not create the team' do
        expect {
          subject.register
        }.not_to change { organization.reload.teams.count }
      end

      it 'does not set the recruiter on the organization' do
        subject.register
        expect(organization.recruiter).to eq(nil)
      end

      it 'does not create a new organization notification job' do
        expect {
          subject.register
        }.not_to have_enqueued_job(NewOrganizationNotificationJob)
      end

      it 'does not create a recruiting ad for the organization' do
        expect {
          subject.register
        }.not_to change { organization.reload.recruiting_ad.present? }
      end
    end

    context 'account persisted' do
      let!(:account) { create(:account, organization: organization) }

      it 'provisions a phone number for the team' do
        subject.register
        expect(Team.last.phone_number).to eq(organization.phone_number)
      end

      it 'sets the recruiter on the team' do
        subject.register
        expect(Team.last.recruiter).to eq(organization.recruiter)
      end

      it 'creates a recruiting ad for the team' do
        subject.register
        expect(Team.last.recruiting_ad).to eq(organization.recruiting_ad)
      end

      it 'provisions a phone number for the organization' do
        expect {
          subject.register
        }.to change { organization.reload.phone_number.present? }.from(false).to(true)
      end

      it 'sets the recruiter on the organization' do
        expect {
          subject.register
        }.to change { organization.reload.recruiter }.from(nil).to(account)
      end

      it 'creates a recruiting ad for the organization' do
        expect {
          subject.register
        }.to change { organization.reload.recruiting_ad.present? }.from(false).to(true)
      end

      it 'adds the account to the team' do
        expect {
          subject.register
        }.to change { account.reload.teams.count }.by(1)
        expect(organization.teams.first.accounts).to include(account)
      end

      it 'creates a new organization notification job' do
        expect {
          subject.register
        }.to have_enqueued_job(NewOrganizationNotificationJob)
      end
    end
  end
end