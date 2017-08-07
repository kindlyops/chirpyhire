class FollowUp < ApplicationRecord
  acts_as_paranoid
  belongs_to :question
  belongs_to :action, class_name: 'BotAction', foreign_key: :bot_action_id

  has_many :follow_ups_tags
  has_many :tags, through: :follow_ups_tags

  validates :body, :action, presence: true
  validates :type, inclusion: { in: %w[ZipcodeFollowUp ChoiceFollowUp] }

  accepts_nested_attributes_for :follow_ups_tags,
                                reject_if: :all_blank, allow_destroy: true

  delegate :bot, to: :question
  delegate :next_question?, :goal?, :question?, to: :action
  delegate :goal, :question, to: :action, prefix: true

  before_validation :ensure_rank

  def action
    return bot.next_question_action if super.blank?

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
