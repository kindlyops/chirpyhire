require 'rails_helper'

RSpec.describe Bot::GoalTrigger do
  let!(:organization) { create(:organization, :team) }
  let(:phone_number) { organization.phone_numbers.first }

  let(:bot) { create(:bot, organization: organization) }
  let(:campaign) { create(:campaign, organization: organization) }
  let(:bot_campaign) { create(:bot_campaign, campaign: campaign, bot: bot) }
  let(:goal) { bot.goals.first }

  let(:team) { organization.teams.first }
  let(:inbox) { team.inbox }
  let(:contact) { create(:contact, organization: organization) }
  let(:conversation) { create(:conversation, inbox: inbox, contact: contact) }

  let(:message) { create(:message, conversation: conversation) }
  let(:campaign_contact) { create(:campaign_contact, :active, phone_number: phone_number, contact: contact, campaign: campaign) }

  subject { Bot::GoalTrigger.new(goal, message, campaign_contact) }

  describe '#call' do
    it 'is the goal body' do
      expect(subject.call).to eq(goal.body)
    end

    it 'sets the campaign_contact to exited' do
      expect {
        subject.call
      }.to change { campaign_contact.state }.from('active').to('exited')
    end

    context 'with multiple accounts on the team' do
      let(:accounts) { create_list(:account, rand(1..3), :person, organization: organization) }
      let!(:account) { accounts.last }
      before do
        team.accounts << accounts
      end

      context 'and an account has a phone number' do
        before do
          account.update(phone_number: Faker::PhoneNumber.cell_phone)
        end

        it 'creates a message to the account' do
          expect {
            subject.call
          }.to change { organization.reload.messages.count }.by(1)

          expect(Message.last.recipient).to eq(account.person)
          expect(Message.last.body).to include('A new candidate is waiting')
        end
      end

      it 'sends an email to the account on the same team only' do
        expect {
          subject.call
        }.to have_enqueued_job(ActionMailer::DeliveryJob)
          .with { |mailer, mailer_method, *_args|
               expect(mailer).to eq('NotificationMailer')
               expect(mailer_method).to eq('contact_ready_for_review')
             }.exactly(team.accounts.count).times
      end

      context 'and alerts are off' do
        before do
          goal.update(alert: false)
        end

        it 'does not send an email to the account on the same team only' do
          expect {
            subject.call
          }.not_to have_enqueued_job(ActionMailer::DeliveryJob)
        end
      end
    end

    it 'broadcasts the contact' do
      expect(Broadcaster::Contact).to receive(:broadcast)

      subject.call
    end
  end
end
