require 'rails_helper'

RSpec.describe NotificationMailer do
  let(:inbox_conversation) { create(:inbox_conversation) }
  let(:account) { inbox_conversation.inbox.account }

  describe 'contact_ready_for_review' do
    let(:mail) { described_class.contact_ready_for_review(inbox_conversation).deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([account.email])
    end
  end

  describe 'contact_waiting' do
    let(:mail) { described_class.contact_waiting(inbox_conversation).deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([account.email])
    end
  end
end
