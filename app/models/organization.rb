class Organization < ApplicationRecord
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

  accepts_nested_attributes_for :location, :stages
  delegate :count, to: :messages, prefix: true
  delegate :latitude, :longitude, to: :location
  delegate :trial_remaining_messages_count, :reached_monthly_message_limit?,
           :inactive?, :active?, :finished_trial?, :trialing?, :plan_name,
           :trial_percentage_remaining, :over_message_limit?, to: :subscription
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

  def get_media(sid)
    messaging_client.media.get(sid)
  end

  def inquiries
    survey.questions.map(&:inquiries).flatten
  end

  def ordered_stages
    stages.ordered
  end

  # There should only ever be one of each default type for an organization
  def bad_fit_stage
    stages.bad_fit.first
  end

  def potential_stage
    stages.potential.first
  end

  def qualified_stage
    stages.qualified.first
  end

  def hired_stage
    stages.hired.first
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

  private

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
