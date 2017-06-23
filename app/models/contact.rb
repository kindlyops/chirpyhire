class Contact < ApplicationRecord
  belongs_to :person
  belongs_to :team
  belongs_to :organization, optional: true
  include RecruitingCounts

  def organization
    super || team.organization
  end

  has_one :contact_candidacy
  has_many :conversations
  has_many :open_conversations, -> { opened }, class_name: 'Conversation'
  has_many :messages, through: :conversations
  has_many :taggings
  has_many :tags, through: :taggings

  has_many :notes

  delegate :handle, :phone_number, :avatar, :nickname, to: :person
  delegate :phone_number, to: :team, prefix: true
  delegate :complete?, :started?, :inquiry, to: :contact_candidacy

  before_create :set_last_reply_at

  def open_conversation
    existing_open_conversation || IceBreaker.call(self)
  end

  def existing_open_conversation
    conversations.opened.first
  end

  def current_conversation
    existing_open_conversation || conversations.by_recent_message.first
  end

  def self.recently_replied
    order('last_reply_at DESC NULLS LAST')
  end

  def self.max_notes_count
    joins(:notes)
      .group('notes.contact_id, contacts.last_reply_at')
      .count.values.max
  end

  def self.tags_filter(tag_ids)
    return current_scope if tag_ids.blank?

    joins(:tags).where('tags.id = ALL (array[?])', tag_ids.map(&:to_i))
  end

  def self.starred_filter(filter_params)
    return current_scope if filter_params.blank?

    where(filter_params)
  end

  def self.zipcode_filter(filter_params)
    return current_scope if filter_params.blank?

    filters = filter_params.map do |k, v|
      sanitize_sql_array(["lower(\"zipcodes\".\"#{k}\") = ?", v.downcase])
    end.join(' AND ')

    joins(person: :zipcode).where(filters)
  end

  def self.incomplete
    includes(:contact_candidacy)
      .where.not('contact_candidacies' => { state: :complete })
  end

  def self.complete
    includes(:contact_candidacy)
      .where('contact_candidacies' => { state: :complete })
  end

  def self.subscribed
    where(subscribed: true)
  end

  def self.unsubscribed
    where(subscribed: false)
  end

  def subscribe
    update(subscribed: true)
  end

  def unsubscribe
    update(subscribed: false)
  end

  def create_message(message, sender)
    open_conversation.messages.create(
      sid: message.sid,
      body: message.body,
      sent_at: message.date_sent,
      external_created_at: message.date_created,
      direction: message.direction,
      sender: sender,
      recipient: person
    ).tap(&:touch_conversation)
  end

  private

  def set_last_reply_at
    self.last_reply_at = DateTime.current
  end
end
