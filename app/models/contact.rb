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

  def create_message(message, sender, phone_number, campaign)
    IceBreaker.call(self, phone_number).messages.create(
      message_params(message, sender, campaign)
    ).tap(&:touch_conversation)
  end

  private

  def message_params(message, sender, campaign)
    base_message_params(message).merge(
      sent_at: message.date_sent,
      external_created_at: message.date_created,
      sender: sender,
      recipient: person,
      campaign: campaign
    )
  end

  def base_message_params(message)
    %i[sid body direction to from].each_with_object({}) do |key, hash|
      hash[key] = message.send(key)
    end
  end

  def set_last_reply_at
    self.last_reply_at = DateTime.current
  end
end
