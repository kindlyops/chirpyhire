class Contact < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  include ContactFilters
  include PgSearch
  pg_search_scope :search_by_name,
                  against: { name: 'A', nickname: 'B' },
                  using: { tsearch: { prefix: true } }

  belongs_to :person
  belongs_to :organization
  belongs_to :stage, class_name: 'ContactStage',
                     foreign_key: :contact_stage_id

  has_many :conversations
  has_many :open_conversations, -> { opened }, class_name: 'Conversation'
  has_many :conversation_parts, through: :conversations
  has_many :messages, through: :conversation_parts
  has_many :taggings
  has_many :tags, through: :taggings

  has_many :contacts_imports
  has_many :imports, through: :contacts_imports

  has_many :campaign_contacts
  has_many :campaigns, through: :campaign_contacts

  has_many :active_campaign_contacts, -> { active },
           class_name: 'CampaignContact'

  has_many :notes

  delegate :handle, :avatar, to: :person

  before_create :set_last_reply_at
  before_validation :add_nickname

  validates :name, presence: true, unless: :nickname_present?
  validates :nickname, presence: true, unless: :name_present?

  def self.active
    joins(conversations: [conversation_parts: :messages])
      .merge(Message.active).distinct
  end

  def self.recently_replied
    order('last_reply_at DESC NULLS LAST')
  end

  def self.max_notes_count
    joins(:notes)
      .group('notes.contact_id, contacts.last_reply_at')
      .count.values.max
  end

  def self.subscribed
    where(subscribed: true)
  end

  def self.unsubscribed
    where(subscribed: false)
  end

  def existing_open_conversation
    conversations.opened.first
  end

  def current_conversation
    existing_open_conversation ||
      conversations.by_recent_conversation_part.first
  end

  def subscribe
    update(subscribed: true)
  end

  def unsubscribe
    update(subscribed: false)
  end

  def handle
    return name if name.present?

    nickname
  end

  def first_name
    return if name.blank?

    name.split(' ', 2).first
  end

  private

  def add_nickname
    return if name.present? || nickname.present?
    self.nickname = Nickname::Generator.new(self).generate
  rescue Nickname::OutOfNicknames => e
    Rollbar.debug(e)
    self.nickname = 'Anonymous'
  end

  def set_last_reply_at
    self.last_reply_at = DateTime.current
  end

  def nickname_present?
    nickname.present?
  end

  def name_present?
    name.present?
  end
end
