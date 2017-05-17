require 'rails_helper'

RSpec.describe Registrar do
  describe 'register' do
    subject { Registrar.new(account) }
    let(:organization) { create(:organization, :team) }
    let(:team) { organization.teams.first }

    before do
      allow(PhoneNumberProvisioner).to receive(:provision) do |team|
        team.update(phone_number: Faker::PhoneNumber.cell_phone)
      end
    end

    context 'account not persisted' do
      let!(:account) { build(:account, organization: organization) }

      it 'does not set the recruiter on the team' do
        subject.register
        expect(team.recruiter).to eq(nil)
      end

      it 'does not create a new organization notification job' do
        expect {
          subject.register
        }.not_to have_enqueued_job(NewOrganizationNotificationJob)
      end

      it 'does not add the account to the team' do
        expect {
          subject.register
        }.not_to change { team.reload.accounts.count }
        expect(team.accounts).not_to include(account)
      end

      it 'does not create a recruiting ad for the team' do
        expect {
          subject.register
        }.not_to change { team.reload.recruiting_ad.present? }
      end
    end

    context 'account persisted' do
      let!(:account) { create(:account, organization: organization) }

      it 'provisions a phone number for the team' do
        expect {
          subject.register
        }.to change { team.reload.phone_number.present? }.from(false).to(true)
      end

      it 'sets the recruiter on the team' do
        expect {
          subject.register
        }.to change { team.reload.recruiter }.from(nil).to(account)
      end

      it 'adds the account to the team' do
        expect {
          subject.register
        }.to change { team.reload.accounts.count }.by(1)
        expect(team.accounts).to include(account)
      end

      it 'creates a recruiting ad for the team' do
        expect {
          subject.register
        }.to change { team.reload.recruiting_ad.present? }.from(false).to(true)
      end

      it 'creates a new organization notification job' do
        expect {
          subject.register
        }.to have_enqueued_job(NewOrganizationNotificationJob)
      end
    end
  end
end
