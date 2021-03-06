require 'rails_helper'

RSpec.describe Registrar do
  describe 'register' do
    let!(:referrer) { nil }
    subject { Registrar.new(account, referrer) }
    let(:organization) { create(:organization, :team_without_inbox) }

    before do
      allow(PhoneNumberProvisioner).to receive(:provision) do |team|
        organization = team.organization
        organization.phone_numbers.create(
          sid: Faker::Number.number(10),
          phone_number: Faker::PhoneNumber.cell_phone
        ).tap do |phone_number|
          organization.assignment_rules.create(
            phone_number: phone_number, inbox: team.inbox
          )
        end
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

      it 'creates a person for the account and the bot' do
        expect {
          subject.register
        }.to change { Person.count }.by(2)
      end

      it 'creates a Potential contact stage' do
        expect {
          subject.register
        }.to change { organization.reload.contact_stages.where(name: 'Potential').exists? }.from(false).to(true)
        expect(organization.reload.contact_stages.find_by(name: 'Potential').rank).to eq(1)
      end

      it 'creates a Hired contact stage' do
        expect {
          subject.register
        }.to change { organization.reload.contact_stages.where(name: 'Hired').exists? }.from(false).to(true)
        expect(organization.reload.contact_stages.find_by(name: 'Hired').rank).to eq(5)
      end

      it 'creates a Archived contact stage' do
        expect {
          subject.register
        }.to change { organization.reload.contact_stages.where(name: 'Archived').exists? }.from(false).to(true)
        expect(organization.reload.contact_stages.find_by(name: 'Archived').rank).to eq(6)
      end

      it 'creates a Not Now contact stage' do
        expect {
          subject.register
        }.to change { organization.reload.contact_stages.where(name: 'Not Now').exists? }.from(false).to(true)
        expect(organization.reload.contact_stages.find_by(name: 'Not Now').rank).to eq(4)
      end

      it 'creates a No Show contact stage' do
        expect {
          subject.register
        }.to change { organization.reload.contact_stages.where(name: 'No Show').exists? }.from(false).to(true)
        expect(organization.reload.contact_stages.find_by(name: 'No Show').rank).to eq(3)
      end

      it 'creates a Scheduled contact stage' do
        expect {
          subject.register
        }.to change { organization.reload.contact_stages.where(name: 'Scheduled').exists? }.from(false).to(true)
        expect(organization.reload.contact_stages.find_by(name: 'Scheduled').rank).to eq(2)
      end

      it 'creates a subscription' do
        expect {
          subject.register
        }.to change { organization.reload.subscription.present? }.from(false).to(true)
      end

      it 'sets the trial ends at on the subscription' do
        subject.register
        expect(organization.reload.subscription.trial_ends_at).to be_present
      end

      it 'creates a bot' do
        expect {
          subject.register
        }.to change { organization.reload.bots.count }.by(1)
      end

      it 'ties the team inbox to the bot' do
        subject.register
        expect(BotCampaign.last.inbox).to eq(Team.last.inbox)
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

      context 'with a referrer' do
        let!(:referrer) { create(:account) }

        it 'sets the referrer on the organization' do
          subject.register

          expect(organization.referrer).to eq(referrer)
        end
      end
    end
  end
end
