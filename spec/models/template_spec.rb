require 'rails_helper'

RSpec.describe Template, type: :model do
  subject { create(:template) }

  describe '#perform' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }

    it 'sends a message to the user' do
      expect {
        subject.perform(user)
      }.to change { FakeMessaging.messages.count }.by(1)
    end

    it 'creates an notification' do
      expect {
        subject.perform(user)
      }.to change { subject.notifications.count }.by(1)
    end
  end
end
