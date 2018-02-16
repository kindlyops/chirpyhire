require 'rails_helper'

RSpec.describe Reminder::Create do
  let!(:reminder) { build(:reminder) }

  subject { Reminder::Create.new(reminder) }

  it 'creates the interview reminder' do
    expect {
      subject.call
    }.to change { Reminder.count }.by(1)
  end

  describe 'more than 24 hours out' do
    before do
      reminder.event_at = 2.days.from_now
    end

    it 'schedules an immediate Reminder notice' do
      expect {
        subject.call
      }.to have_enqueued_job(ReminderCreatedJob)
    end
  end

  describe 'fewer than 24 hours out' do
    describe 'less than 1 hour out' do
      before do
        reminder.event_at = 30.minutes.from_now
      end

      it 'schedules an immediate Reminder notice' do
        expect {
          subject.call
        }.to have_enqueued_job(ReminderCreatedJob)
      end

      it 'set the day_before_alert to false' do
        subject.call
        expect(Reminder.last.send_day_before_alert?).to eq(false)
      end

      it 'set the hour_before_alert to false' do
        subject.call
        expect(Reminder.last.send_hour_before_alert?).to eq(false)
      end
    end

    describe 'more than 1 hour out' do
      before do
        reminder.event_at = 3.hours.from_now
      end

      it 'set the day_before_alert to false' do
        subject.call
        expect(Reminder.last.send_day_before_alert?).to eq(false)
      end

      it 'schedules an immediate Reminder notice' do
        expect {
          subject.call
        }.to have_enqueued_job(ReminderCreatedJob)
      end
    end
  end
end
