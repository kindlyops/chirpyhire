class Goal < ApplicationRecord
  belongs_to :bot

  has_many :goals_tags
  has_many :tags, through: :goals_tags

  def trigger(message, campaign_contact)
    Bot::GoalTrigger.call(self, message, campaign_contact)
  end

  def tag(contact)
    contact.tags << goal.tags
  end
end
