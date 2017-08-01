require 'rails_helper'

RSpec.describe ManualMessageParticipant::Runner do
  let!(:organization) { create(:organization, :team_with_phone_number_and_recruiting_ad_and_inbox) }
  let(:account) { create(:account, organization: organization) }
  let(:manual_message) { create(:manual_message, account: account) }
  let(:contact) { create(:contact, organization: organization) }
  let(:participant) { create(:manual_message_participant, contact: contact, manual_message: manual_message) }

  subject { ManualMessageParticipant::Runner.new(participant) }

  describe 'call' do
    context 'message already present' do
      let(:message) { create(:message) }
      before do
        participant.update(message: message)
      end

      it 'does not create a new message' do
        expect {
          subject.call
        }.not_to change { Message.count }
      end

      it 'does not update the participant' do
        expect {
          subject.call
        }.not_to change { participant.reload.message }

        expect(participant.message).to eq(message)
      end
    end

    context 'message not present' do
      it 'creates a new message' do
        expect {
          subject.call
        }.to change { Message.count }.by(1)
      end

      it 'updates the participant to be tied to the new message' do
        expect {
          subject.call
        }.to change { participant.reload.message }.from(nil)
      end
    end
  end
end
