class FollowUp < ApplicationRecord
  acts_as_paranoid
  belongs_to :question
  belongs_to :action, class_name: 'BotAction', foreign_key: :bot_action_id

  has_many :taggings, class_name: 'FollowUpsTag'
  has_many :tags, through: :taggings

  validates :body, :action, presence: true
  validates :type, inclusion: { in: %w[ZipcodeFollowUp ChoiceFollowUp] }

  accepts_nested_attributes_for :taggings
  accepts_nested_attributes_for :tags

  delegate :bot, to: :question
  delegate :next_question?, :goal?, :question?, to: :action
  delegate :goal, :question, to: :action, prefix: true

  before_validation :ensure_rank

  def action
    return if super.blank?

    super.becomes(super.type.constantize)
  end

  def self.ranked
    order(:rank)
  end

  def tag(contact, message)
    TemplateTagger.call(self, contact, message)
  end

  def trigger(message, campaign_contact)
    Bot::FollowUpTrigger.call(self, message, campaign_contact)
  end

  private

  def ensure_rank
    return if rank.present?
    self.rank = question.next_follow_up_rank
  end
end
