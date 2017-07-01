require 'rails_helper'

RSpec.describe Registrar do
  describe 'register' do
    subject { Registrar.new(account) }
    let(:organization) { create(:organization, :team_without_inbox) }

    before do
      allow(PhoneNumberProvisioner).to receive(:provision) do |team|
        phone_number = organization.phone_numbers.create(
          sid: Faker::Number.number(10),
          phone_number: Faker::PhoneNumber.cell_phone
        )
        organization.assignment_rules.create(
          phone_number: phone_number, inbox: team.inbox
        )
      end
    end

    context 'account not persisted' do
      let!(:account) { build(:account, organization: organization) }

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

      it 'sets the account as an owner on the organization' do
        expect {
          subject.register
        }.to change { account.reload.owner? }.from(false).to(true)
      end

      it 'creates an inbox' do
        expect {
          subject.register
        }.to change { Inbox.count }.by(1)
      end

      it 'creates an assignment rule' do
        expect {
          subject.register
        }.to change { organization.assignment_rules.count }.by(1)
      end

      it 'creates a phone number' do
        expect {
          subject.register
        }.to change { organization.phone_numbers.count }.by(1)
      end

      it 'sets the recruiter on the team' do
        subject.register
        expect(Team.last.recruiter).to eq(account)
      end

      it 'creates a recruiting ad for the team' do
        subject.register
        expect(Team.last.recruiting_ad).to eq(organization.recruiting_ad)
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

      it 'does not create a new team notification job' do
        expect {
          subject.register
        }.not_to have_enqueued_job(NewTeamNotificationJob)
      end
    end
  end
end
