require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, :with_account, :with_survey) }

  describe '#send_message' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }

    it 'sends the sms message' do
      expect {
        organization.send_message(to: user.phone_number, body: 'Test')
      }.to change { FakeMessaging.messages.count }.by(1)
    end
  end

  describe '#conversations' do
    let!(:candidates) { create_list(:candidate, 3, :with_message, message_count: 2, organization: organization) }
    it 'only pulls one message per candidate' do
      expect(organization.messages.count).to be > candidates.count
      expect(organization.conversations.count).to eq(candidates.count)
    end

    it 'is the latest message' do
      expect(organization.conversations).to include(candidates.first.messages.order(:external_created_at).reverse.first)
    end

  end

  it '#before_create has stages' do
    expect(organization.stages).not_to be_empty
  end
end
