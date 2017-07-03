class Campaign < ApplicationRecord
  belongs_to :organization
  has_one :bot_campaign
  has_one :bot, through: :bot_campaign

  has_many :campaign_contacts
  has_many :contact, through: :campaign_contacts

  has_many :messages

  def reply(response)
    organization.message(
      sender: response.sender,
      conversation: response.conversation,
      body: response.body
    )
  end
end
