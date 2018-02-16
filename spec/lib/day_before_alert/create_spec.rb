require 'rails_helper'

RSpec.describe DayBeforeAlert::Create do
  let!(:reminder) { create(:reminder) }

  subject { DayBeforeAlert::Create.new(reminder) }

  context 'should send day before alert' do
    context 'has not sent day before alert' do
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

      context 'seeker is unsubscribed' do
        before do
          reminder.application.seeker.update(text_subscribed: false)
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
