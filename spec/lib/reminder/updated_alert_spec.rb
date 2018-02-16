require 'rails_helper'

RSpec.describe Reminder::UpdatedAlert do
  let!(:reminder) { create(:reminder) }

  subject { Reminder::UpdatedAlert.new(reminder) }

  context 'not deleted' do
    it 'sends a text to the Seeker' do
      expect {
        subject.call
      }.to change { Textris::Base.deliveries.count }.by(1)
    end

    it 'updates last_updated_alert_sent_at' do
      expect {
        subject.call
      }.to change { reminder.reload.last_updated_alert_sent_at }
    end
  end

  context 'seeker unsubscribed' do
    before do
      reminder.application.seeker.update(text_subscribed: false)
    end

    it 'does not send a text to the Seeker' do
      expect {
        subject.call
      }.not_to change { Textris::Base.deliveries.count }
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

    it 'does not send a text to the Seeker' do
      expect {
        subject.call
      }.not_to change { Textris::Base.deliveries.count }
    end

    it 'does not update last_updated_alert_sent_at' do
      expect {
        subject.call
      }.not_to change { reminder.reload.last_updated_alert_sent_at }
    end
  end
end
