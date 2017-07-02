class Bot < ApplicationRecord
  belongs_to :organization
  belongs_to :person
  belongs_to :last_edited_by, optional: true, class_name: 'Account'

  has_one :greeting
  has_many :questions
  has_many :goals

  has_many :bot_campaigns
  has_many :inboxes, through: :bot_campaigns
  has_many :campaigns, through: :bot_campaigns

  def receive(message)
    BotDeliveryAgent.call(self, message)
  end

  def activated?(message)
    Bot::Trigger.new(self, message).activated?
  end
end
