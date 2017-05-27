require 'rails_helper'

RSpec.describe NotificationMailer do

  describe 'contact_ready_for_review' do
    let(:conversation) { create(:inbox_conversation) }
    let(:mail) { described_class.contact_ready_for_review(conversation).deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([conversation.inbox.account.email])
    end
  end

  describe 'contact_waiting' do
    let(:conversation) { create(:inbox_conversation) }
    let(:mail) { described_class.contact_waiting(conversation).deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([conversation.inbox.account.email])
    end
  end
end
