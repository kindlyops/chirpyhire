require 'rails_helper'

RSpec.describe Reminder::HourBeforeAlert do
  let!(:reminder) { create(:reminder) }

  before do
    create(:bot, organization: reminder.contact.organization)
  end
  
  subject { Reminder::HourBeforeAlert.new(reminder) }

  context 'should send hour before alert' do
    context 'has not sent hour before alert' do
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
        }.to change { reminder.reload.hour_before_alert_sent_at }
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
          }.not_to change { reminder.reload.hour_before_alert_sent_at }
        end
      end
    end

    context 'has sent hour before alert' do
      before do
        reminder.update(hour_before_alert_sent_at: DateTime.current)
      end

      it 'does not send the alert' do
        expect {
          subject.call
        }.not_to change { Message.count }
      end

      it 'does not log the alert as sent' do
        expect {
          subject.call
        }.not_to change { reminder.reload.hour_before_alert_sent_at }
      end
    end
  end
end
