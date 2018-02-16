require 'rails_helper'

RSpec.describe Reminder::Destroy do
  let!(:reminder) { create(:reminder) }

  subject { Reminder::Destroy.new(reminder) }

  it 'destroys the interview reminder' do
    expect {
      subject.call
    }.to change { Reminder.count }.by(-1)
  end

  it 'schedules an immediate Reminder deleted notice' do
    expect {
      subject.call
    }.to have_enqueued_job(ReminderDestroyedJob)
  end

  describe 'more than 24 hours out' do
    before do
      reminder.update(event_at: 2.days.from_now)
    end

    it 'sets day_before_alert to false' do
      subject.call
      expect(reminder.reload.send_day_before_alert?).to eq(false)
    end

    it 'sets hour_before_alert to false' do
      subject.call
      expect(reminder.reload.send_hour_before_alert?).to eq(false)
    end
  end

  describe 'fewer than 24 hours out' do
    context 'more than 1 hour out' do
      before do
        reminder.update(event_at: 3.hours.from_now)
      end

      it 'sets hour_before_alert to false' do
        subject.call
        expect(reminder.reload.send_hour_before_alert?).to eq(false)
      end
    end

    context 'less than 1 hour out' do
      before do
        reminder.update(event_at: 30.minutes.from_now)
      end

      it 'does not set hour_before_alert to false' do
        subject.call
        expect(reminder.reload.send_hour_before_alert?).not_to eq(false)
      end
    end
  end
end
