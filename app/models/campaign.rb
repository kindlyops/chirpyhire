class Campaign < ApplicationRecord
  belongs_to :organization
  belongs_to :account
  belongs_to :last_edited_by, class_name: 'Account'

  has_one :bot_campaign
  has_one :bot, through: :bot_campaign

  has_many :campaign_contacts
  has_many :contact, through: :campaign_contacts

  has_many :conversation_parts
  has_many :messages, through: :conversation_parts
  accepts_nested_attributes_for :bot_campaign

  validates :name, uniqueness: { scope: :organization }
  validates :name, presence: true

  enum status: {
    active: 0, paused: 1
  }

  def self.recent
    order(created_at: :desc)
  end
end
