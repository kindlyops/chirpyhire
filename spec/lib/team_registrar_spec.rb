require 'rails_helper'

RSpec.describe TeamRegistrar do
  describe 'call' do
    let(:organization) { create(:organization, :team_without_inbox) }
    let(:account) { create(:account, organization: organization) }
    let(:team) { organization.teams.first }
    subject { TeamRegistrar.new(team, account) }

    before do
      allow(PhoneNumberProvisioner).to receive(:provision) do |team|
        phone = Faker::PhoneNumber.cell_phone
        team.update(phone_number: phone)
      end
    end

    it 'creates the inbox' do
      expect {
        subject.call
      }.to change { TeamInbox.count }.by(1)
    end

    it 'provisions a phone number for the team' do
      subject.call
      expect(Team.last.phone_number.present?).to eq(true)
    end

    it 'sets the recruiter on the team' do
      subject.call
      expect(Team.last.recruiter).to eq(account)
    end

    it 'creates a recruiting ad for the team' do
      expect {
        subject.call
      }.to change { RecruitingAd.count }.by(1)
    end

    it 'sets the recruiter on the team' do
      expect {
        subject.call
      }.to change { team.reload.recruiter }.from(nil).to(account)
    end

    it 'adds the account to the team' do
      expect {
        subject.call
      }.to change { account.reload.teams.count }.by(1)
      expect(organization.teams.first.accounts).to include(account)
    end

    it 'promotes the account on the team to manager' do
      subject.call
      membership = team.memberships.find_by(account: account)
      expect(membership.manager?).to eq(true)
    end

    it 'creates a new team notification job' do
      expect {
        subject.call
      }.to have_enqueued_job(NewTeamNotificationJob)
    end
  end
end
