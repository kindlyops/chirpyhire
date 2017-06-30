class Bot < ApplicationRecord
  belongs_to :organization
  belongs_to :last_edited_by, optional: true, class_name: 'Account'

  has_one :greeting
  has_many :questions
  has_many :goals
  has_many :on_calls
  has_many :inboxes, through: :on_calls

  has_many :bot_campaigns
  has_many :campaigns, through: :bot_campaigns
end
