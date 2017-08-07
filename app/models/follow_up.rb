class FollowUp < ApplicationRecord
  acts_as_paranoid
  belongs_to :question
  belongs_to :bot_action, optional: true
  belongs_to :next_question, optional: true, class_name: 'Question'
  belongs_to :goal, optional: true

  has_many :follow_ups_tags
  has_many :tags, through: :follow_ups_tags

  validates :body, :action, presence: true
  validates :type, inclusion: { in: %w[ZipcodeFollowUp ChoiceFollowUp] }

  enum action: {
    next_question: 0, question: 1, goal: 2
  }

  accepts_nested_attributes_for :follow_ups_tags,
                                reject_if: :all_blank, allow_destroy: true

  delegate :bot, to: :question

  before_validation :ensure_rank

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
