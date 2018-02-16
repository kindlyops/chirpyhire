require 'rails_helper'

RSpec.describe Reminder::Update do
  let!(:reminder) { create(:reminder) }
  let(:event_at) { reminder.event_at }
  let(:attributes) { { event_at: event_at } }
  let(:datetime) { build(:reminder, event_at: event_at).to_datetime }

  subject { Reminder::Update.new(reminder, attributes) }

  it 'does not create the interview reminder' do
    expect {
      subject.call
    }.not_to change { Reminder.count }
  end

  describe 'more than 24 hours out' do
    let(:event_at) { 10.days.from_now }

    it 'schedules an immediate Reminder notice' do
      expect {
        subject.call
      }.to have_enqueued_job(ReminderUpdatedJob)
    end
  end

  describe 'fewer than 24 hours out' do
    describe 'less than 1 hour out' do
      let(:event_at) { 30.minutes.from_now }

      it 'schedules an immediate Reminder notice' do
        expect {
          subject.call
        }.to have_enqueued_job(ReminderUpdatedJob)
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
      let(:event_at) { 3.hours.from_now }

      it 'set the day_before_alert to false' do
        subject.call
        expect(Reminder.last.send_day_before_alert?).to eq(false)
      end

      it 'schedules an immediate Reminder notice' do
        expect {
          subject.call
        }.to have_enqueued_job(ReminderUpdatedJob)
      end
    end
  end
end
