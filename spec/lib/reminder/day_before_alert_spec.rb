require 'rails_helper'

RSpec.describe Reminder::DayBeforeAlert do
  let!(:reminder) { create(:reminder) }

  subject { Reminder::DayBeforeAlert.new(reminder) }

  context 'should send day before alert' do
    context 'has not sent day before alert' do
      before do
        allow(reminder.contact.organization).to receive(:message) { create(:message) }
      end

      it 'sends the alert' do
        expect {
          subject.call
        }.to change { Message.count }.by(1)
      end

      it 'logs the alert as sent' do
        expect {
          subject.call
        }.to change { reminder.reload.day_before_alert_sent_at }
      end

      context 'contact is unsubscribed' do
        before do
          reminder.contact.update(subscribed: false)
        end

        it 'does not send the alert' do
          expect {
            subject.call
          }.not_to change { Message.count }
        end

        it 'does not log the alert as sent' do
          expect {
            subject.call
          }.not_to change { reminder.reload.day_before_alert_sent_at }
        end
      end
    end

    context 'has sent day before alert' do
      before do
        reminder.update(day_before_alert_sent_at: DateTime.current)
      end

      it 'does not send the alert' do
        expect {
          subject.call
        }.not_to change { Message.count }
      end

      it 'does not log the alert as sent' do
        expect {
          subject.call
        }.not_to change { reminder.reload.day_before_alert_sent_at }
      end
    end
  end
end
