class Reminder < ApplicationRecord
  acts_as_paranoid
  belongs_to :contact
  delegate :time_zone, to: :event_at

  def self.future
    where('reminders.event_at > ?', DateTime.current)
  end

  def self.next
    return unless future.exists?

    future.order(:event_at).first
  end

  def formatted
    "#{formatted_day} #{formatted_time}"
  end

  def week_day
    Date::DAYNAMES[event_at.wday]
  end

  def create_unsendable?
    contact.text_unsubscribed? || deleted? || sent_created_alert?
  end

  def delete_unsendable?
    contact.text_unsubscribed? || !deleted? || sent_destroyed_alert?
  end

  def update_unsendable?
    contact.text_unsubscribed? || deleted?
  end

  def formatted_day
    event_at.strftime('%b %d, %Y')
  end

  def formatted_time
    event_at.strftime('%l:%M %p')
  end

  def formatted_time_zone
    event_at.strftime('%Z')
  end

  def end_time
    to_datetime.advance(hours: 1).strftime('%m/%d/%Y %l:%M %p')
  end

  def start_time
    to_datetime.strftime('%m/%d/%Y %l:%M %p')
  end

  def to_datetime
    event_at
  end

  def tzinfo_time_zone
    time_zone.tzinfo.name
  end

  def email_alarm_reminder(user)
    return 15 if user.account?
    60
  end

  def sent_destroyed_alert?
    destroyed_alert_sent_at.present?
  end

  def sent_created_alert?
    created_alert_sent_at.present?
  end

  def sent_hour_before_alert?
    hour_before_alert_sent_at.present?
  end

  def sent_day_before_alert?
    day_before_alert_sent_at.present?
  end

  def send_hour_before_alert?
    contact.text_subscribed? && super && !sent_hour_before_alert?
  end

  def send_day_before_alert?
    contact.text_subscribed? && super && !sent_day_before_alert?
  end
end
