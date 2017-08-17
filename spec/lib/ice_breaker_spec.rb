require 'rails_helper'

RSpec.describe IceBreaker do
  let(:organization) { create(:organization, :team) }
  let(:phone_number) { organization.phone_numbers.first }
  let(:team) { organization.teams.first }
  let(:contact) { create(:contact, organization: organization) }

  subject { IceBreaker.new(contact, phone_number) }

  describe '#call' do
    context 'with assignment rule between phone_number and team inbox' do
      it 'creates a conversation and ties it to the contact team inbox' do
        expect {
          subject.call
        }.to change { team.reload.conversations.count }.by(1)
      end
    end

    context 'closed existing conversation' do
      let!(:conversation) { create(:conversation, :closed, contact: contact, inbox: team.inbox, phone_number: phone_number) }

      context 'that was closed in the last hour' do
        it 'returns the existing closed conversation' do
          expect {
            subject.call
          }.not_to change { team.reload.conversations.count }
        end
      end

      context 'that was closed more than an hour ago' do
        before do
          conversation.update(closed_at: 70.minutes.ago)
        end

        it 'creates a new conversation' do
          expect {
            subject.call
          }.to change { team.reload.conversations.count }.by(1)
        end
      end
    end
  end
end
