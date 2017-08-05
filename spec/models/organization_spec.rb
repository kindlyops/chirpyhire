require 'rails_helper'

RSpec.describe Organization do
  subject { create(:organization, :team, :account) }
  let!(:team) { subject.teams.first }
  let!(:account) { subject.accounts.first }

  describe '#message' do
    let(:contact) { create(:contact, organization: subject) }
    let(:conversation) { create(:conversation, contact: contact, inbox: team.inbox) }

    before do
      allow(Broadcaster::Part).to receive(:broadcast)
    end

    it 'creates a conversation part' do
      expect {
        subject.message(conversation: conversation, body: 'body', sender: account.person)
      }.to change { conversation.reload.parts.count }.by(1)
    end

    context 'campaign' do
      let(:campaign) { create(:campaign) }
      it 'assigns the message to the campaign' do
        expect {
          subject.message(conversation: conversation, body: 'body', sender: account.person, campaign: campaign)
        }.to change { campaign.reload.messages.count }.by(1)
      end
    end
  end
end
