class Campaign < ApplicationRecord
  belongs_to :organization
  has_one :bot_campaign
  has_one :bot, through: :bot_campaign

  has_many :campaign_contacts
  has_many :contact, through: :campaign_contacts

  has_many :messages
  accepts_nested_attributes_for :bot_campaign

  validates :name, uniqueness: true
  validates :name, presence: true

  def self.recent
    order(created_at: :desc)
  end
end
