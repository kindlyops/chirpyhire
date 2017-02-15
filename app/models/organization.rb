class Organization < ApplicationRecord
  include Stageable
  phony_normalize :phone_number, default_country_code: 'US'

  has_many :users
  has_many :candidates, through: :users
  has_many :candidate_activities, through: :candidates, source: :activities
  has_many :referrers, through: :users
  has_many :accounts, through: :users
  has_many :messages, through: :users
  has_many :templates
  has_many :rules
  has_many :stages
  has_one :survey
  has_one :location
  has_one :subscription

  accepts_nested_attributes_for :location
  delegate :count, to: :messages, prefix: true
  delegate :latitude, :longitude, to: :location
  delegate :trial_remaining_messages_count, :reached_monthly_message_limit?,
           :good_standing?, :active?, :finished_trial?, :trialing?,
           :plan_name, :trial_percentage_remaining, :over_message_limit?,
           to: :subscription
  delegate :price, :state, to: :subscription, prefix: true

  def send_message(to:, body:, from: phone_number)
    sent_message = messaging_client.send_message(to: to, body: body, from: from)

    Message.new(sid: sent_message.sid, body: sent_message.body,
                sent_at: sent_message.date_sent,
                external_created_at: sent_message.date_created,
                direction: sent_message.direction)
  end

  def persisted_subscription?
    subscription.present? && subscription.persisted?
  end

  def new_subscription?
    subscription.present? && subscription.new_record?
  end

  def current_month_messages_count
    messages.current_month.count
  end

  def last_month_messages_count
    messages.last_month.count
  end

  def get_message(sid)
    messaging_client.messages.get(sid)
  end

  def inquiries
    survey.questions.map(&:inquiries).flatten
  end

  def ordered_stages
    stages.ordered
  end

  def bad_fit_candidate_activities
    candidate_activities.for_stage(bad_fit_stage)
  end

  def potential_candidate_activities
    candidate_activities.for_stage(potential_stage)
  end

  def qualified_candidate_activities
    candidate_activities.for_stage(qualified_stage)
  end

  def hired_candidate_activities
    candidate_activities.for_stage(hired_stage)
  end

  def default_display_stage
    qualified_stage
  end

  # rubocop:disable Metrics/LineLength, Metrics/MethodLength
  def conversations
    Message.where(id: ActiveRecord::Base.connection.select_values("
    SELECT m.id
    FROM messages AS m
      JOIN users AS u
        ON m.user_id = u.id
      JOIN candidates AS c
        ON u.id = c.user_id
      LEFT OUTER JOIN messages AS m2
        ON m.user_id = m2.user_id
          AND (m.external_created_at < m2.external_created_at
            OR (m.external_created_at = m2.external_created_at AND m.id < m2.id))
    WHERE u.organization_id = #{id} AND m2.user_id IS NULL"))
  end
  # rubocop:enable Metrics/LineLength, Metrics/MethodLength

  before_create do |organization|
    StageDefaults.populate(organization)
  end

  def recent_unread_messages_by_user(since_date_time)
    Message.joins(user: :candidate)
           .order(external_created_at: :desc)
           .where("users.organization_id = ?
              AND users.has_unread_messages = TRUE
              AND messages.direction = 'inbound'
              AND messages.external_created_at > ?",
                  id, since_date_time)
           .group_by(&:user_id).map { |g| g[1].first }
  end

  private

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
