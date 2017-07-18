class Goal < ApplicationRecord
  belongs_to :bot

  has_many :goals_tags
  has_many :tags, through: :goals_tags
  validates :rank, :body, presence: true

  enum outcome: {
    'New' => 0, 'Screened' => 1, 'Not Now' => 2, 'Scheduled' => 3
  }

  before_validation :ensure_rank

  def self.ranked
    order(:rank)
  end

  def trigger(message, campaign_contact)
    Bot::GoalTrigger.call(self, message, campaign_contact)
  end

  def tag(contact)
    contact.update(outcome: outcome)
    contact.tags << tags
  end

  private

  def ensure_rank
    return if rank.present?
    self.rank = bot.next_goal_rank
  end
end
