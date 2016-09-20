require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, :with_account, :with_survey) }

  describe '#send_message' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }

    it 'sends the sms message' do
      expect{
        organization.send_message(to: user.phone_number, body: 'Test')
      }.to change { FakeMessaging.messages.count }.by(1)
    end
  end
end
