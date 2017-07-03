require 'rails_helper'

RSpec.describe Organization do
  subject { create(:organization, :team, :account) }
  let!(:team) { subject.teams.first }
  let!(:account) { subject.accounts.first }

  describe '#message' do
    let(:contact) { create(:contact, organization: subject) }
    let(:conversation) { create(:conversation, contact: contact, inbox: team.inbox) }

    before do
      allow(Broadcaster::Message).to receive(:broadcast)
    end
    context 'reached' do
      context 'sent by bot' do
        let(:bot) { create(:bot, organization: subject) }
        context 'and reached is false' do
          it 'leaves reached at false' do
            expect {
              subject.message(conversation: conversation, body: 'body', sender: bot.person)
            }.not_to change { contact.reload.reached? }
            expect(contact.reached?).to eq(false)
          end
        end
      end

      context 'sent by an account on the team' do
        context 'and reached is false' do
          it 'sets reached to true' do
            expect {
              subject.message(conversation: conversation, body: 'body', sender: account.person)
            }.to change { contact.reload.reached? }.from(false).to(true)
          end
        end
      end
    end
  end
end
