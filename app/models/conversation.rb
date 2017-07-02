class Conversation < ApplicationRecord
  belongs_to :contact
  belongs_to :inbox
  belongs_to :phone_number

  has_many :campaign_conversations
  has_many :campaigns, through: :campaign_conversations

  has_one :active_campaign_conversation, -> { active },
          class_name: 'CampaignConversation'
  has_one :active_campaign, through: :active_campaign_conversation,
                            class_name: 'Campaign', source: :campaign
  has_one :active_bot_campaign, through: :active_campaign,
                                class_name: 'BotCampaign',
                                source: :bot_campaign
  has_one :active_bot, through: :active_bot_campaign,
                       class_name: 'Bot',
                       source: :bot

  has_many :messages
  has_many :read_receipts

  has_one :recent_message,
          -> { by_recency.limit(1) }, class_name: 'Message'

  delegate :person, :handle, :organization, to: :contact
  delegate :handle, to: :contact, prefix: true

  def contact_phone_number
    contact.phone_number.phony_formatted
  end

  enum state: {
    'Open' => 0, 'Closed' => 1
  }

  def self.opened
    where(state: 'Open')
  end

  def self.by_recent_message
    order(last_message_created_at: :desc)
  end

  def open?
    state == 'Open'
  end

  def closed?
    state == 'Closed'
  end

  def reopenable?
    contact.open_conversations.where(phone_number: phone_number).none?
  end
end
