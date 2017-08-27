class Goal < ApplicationRecord
  acts_as_paranoid
  belongs_to :bot
  belongs_to :contact_stage, optional: true
  has_one :action, class_name: 'GoalAction', dependent: :destroy

  validates :rank, :body, presence: true
  before_validation :ensure_rank

  delegate :follow_ups, to: :action
  delegate :organization, :last_edited_by, to: :bot

  def self.ranked
    order(:rank)
  end

  def trigger(message, campaign_contact)
    Bot::GoalTrigger.call(self, message, campaign_contact)
  end

  def tag(contact)
    update_contact_stage(contact) if contact_stage.present?
  end

  private

  def ensure_rank
    return if rank.present?
    self.rank = bot.next_goal_rank
  end

  def update_contact_stage(contact)
    contact.update(stage: contact_stage)
    log_stage_change(contact)
  end

  def log_stage_change(contact)
    Internal::Logger::SetContactStage.call(
      last_edited_by,
      contact,
      contact_stage
    )
  end
end
