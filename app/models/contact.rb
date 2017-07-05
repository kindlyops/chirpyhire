class Contact < ApplicationRecord
  belongs_to :person
  belongs_to :organization
  include RecruitingCounts

  has_one :contact_candidacy
  has_many :conversations
  has_many :open_conversations, -> { opened }, class_name: 'Conversation'
  has_many :messages, through: :conversations
  has_many :taggings
  has_many :tags, through: :taggings

  has_many :campaign_contacts
  has_many :campaigns, through: :campaign_contacts

  has_many :active_campaign_contacts, -> { active },
           class_name: 'CampaignContact'

  has_many :notes

  delegate :handle, :phone_number, :avatar, :nickname, to: :person
  delegate :complete?, :started?, :inquiry, to: :contact_candidacy

  before_create :set_last_reply_at

  def self.screened
    joins(taggings: :tag).merge(Tag.screened)
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

  def self.tag_filter(tag_ids)
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

  private

  def set_last_reply_at
    self.last_reply_at = DateTime.current
  end
end
