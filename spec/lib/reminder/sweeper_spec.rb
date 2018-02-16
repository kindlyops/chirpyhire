require 'rails_helper'

RSpec.describe Reminder::Sweeper do
  let!(:reminder) { build(:reminder) }

  subject { Reminder::Sweeper.new }

  context 'interview reminder in the past' do
    before do
      reminder.update(event_at: 30.days.ago)
    end

    it 'does kick off a DayBeforeAlertJob' do
      expect {
        subject.call
      }.to have_enqueued_job(DayBeforeAlertJob)
    end

    it 'does kick off a HourBeforeAlertJob' do
      expect {
        subject.call
      }.to have_enqueued_job(HourBeforeAlertJob)
    end
  end

  context 'interview reminder in the future' do
    context 'less than an hour in the future' do
      before do
        reminder.update(event_at: DateTime.current.advance(minutes: 30))
      end

      it 'does kick off a DayBeforeAlertJob' do
        expect {
          subject.call
        }.to have_enqueued_job(DayBeforeAlertJob)
      end

      it 'does kick off a HourBeforeAlertJob' do
        expect {
          subject.call
        }.to have_enqueued_job(HourBeforeAlertJob)
      end
    end

    context 'an hour in the future' do
      before do
        reminder.update(event_at: DateTime.current.advance(hours: 1))
      end

      it 'does kick off a DayBeforeAlertJob' do
        expect {
          subject.call
        }.to have_enqueued_job(DayBeforeAlertJob)
      end

      it 'does kick off a HourBeforeAlertJob' do
        expect {
          subject.call
        }.to have_enqueued_job(HourBeforeAlertJob)
      end
    end

    context 'more than an hour in the future but less than a day' do
      before do
        reminder.update(event_at: DateTime.current.advance(hours: 10))
      end

      it 'does not kick off a DayBeforeAlertJob' do
        expect {
          subject.call
        }.to have_enqueued_job(DayBeforeAlertJob)
      end

      it 'does not kick off a HourBeforeAlertJob' do
        expect {
          subject.call
        }.not_to have_enqueued_job(HourBeforeAlertJob)
      end
    end

    context 'a day in the future' do
      before do
        reminder.update(event_at: 1.day.from_now)
      end

      it 'does kick off a DayBeforeAlertJob' do
        expect {
          subject.call
        }.to have_enqueued_job(DayBeforeAlertJob)
      end

      it 'does not kick off a HourBeforeAlertJob' do
        expect {
          subject.call
        }.not_to have_enqueued_job(HourBeforeAlertJob)
      end
    end

    context 'more than a day in the future' do
      before do
        reminder.update(event_at: 3.days.from_now)
      end

      it 'does not kick off a DayBeforeAlertJob' do
        expect {
          subject.call
        }.not_to have_enqueued_job(DayBeforeAlertJob)
      end

      it 'does not kick off a HourBeforeAlertJob' do
        expect {
          subject.call
        }.not_to have_enqueued_job(HourBeforeAlertJob)
      end
    end
  end
end
