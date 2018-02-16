require 'rails_helper'

RSpec.describe Reminder::UpdatedAlert do
  let!(:reminder) { create(:reminder) }

  before do
    create(:bot, organization: reminder.contact.organization)
  end

  subject { Reminder::UpdatedAlert.new(reminder) }

  context 'not deleted' do
    before do
      allow(reminder.contact.organization).to receive(:message) { create(:message) }
    end

    it 'sends a text to the Contact' do
      expect {
        subject.call
      }.to change { Message.count }.by(1)
    end

    it 'updates last_updated_alert_sent_at' do
      expect {
        subject.call
      }.to change { reminder.reload.last_updated_alert_sent_at }
    end
  end

  context 'contact unsubscribed' do
    before do
      reminder.contact.update(subscribed: false)
    end

    it 'does not send a text to the Contact' do
      expect {
        subject.call
      }.not_to change { Message.count }
    end

    it 'does not update last_updated_alert_sent_at' do
      expect {
        subject.call
      }.not_to change { reminder.reload.last_updated_alert_sent_at }
    end
  end

  context 'deleted' do
    before do
      reminder.destroy
    end

    it 'does not send a text to the Contact' do
      expect {
        subject.call
      }.not_to change { Message.count }
    end

    it 'does not update last_updated_alert_sent_at' do
      expect {
        subject.call
      }.not_to change { reminder.reload.last_updated_alert_sent_at }
    end
  end
end
