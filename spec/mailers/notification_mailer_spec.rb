require 'rails_helper'

RSpec.describe NotificationMailer do
  let(:account) { create(:account) }
  let(:conversation) { create(:conversation) }

  describe 'contact_ready_for_review' do
    let(:mail) { described_class.contact_ready_for_review(account, conversation).deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([account.email])
    end
  end

  describe 'contact_waiting' do
    let(:mail) { described_class.contact_waiting(account, conversation).deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([account.email])
    end
  end
end
