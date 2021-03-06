class Question < ApplicationRecord
  acts_as_paranoid
  belongs_to :bot
  has_many :campaign_contacts
  has_many :follow_ups
  has_many :ranked_follow_ups, -> { ranked }, class_name: 'FollowUp'
  has_one :action, class_name: 'QuestionAction', dependent: :destroy

  validates :rank, presence: true
  validates :type, inclusion: { in: %w[ZipcodeQuestion ChoiceQuestion] }

  accepts_nested_attributes_for :follow_ups,
                                reject_if: :all_blank, allow_destroy: true

  validate :unformatted_body
  before_validation :ensure_rank

  delegate :follow_ups, to: :action, prefix: true

  def self.ranked
    order(:rank)
  end

  def body(*)
    self[:body]
  end

  def self.active
    where(active: true)
  end

  def trigger(_message, campaign_contact)
    campaign_contact.update(question: self)
    body
  end

  def follow_up(message, campaign_contact)
    Bot::QuestionFollowUp.call(self, message, campaign_contact)
  end

  def last_follow_up
    ranked_follow_ups.last
  end

  def next_follow_up_rank
    return 1 if last_follow_up.blank?

    last_follow_up.rank + 1
  end

  def answers
    ''
  end

  private

  def unformatted_body
    errors.add(:body, "can't be blank") if body(formatted: false).blank?
  end

  def ensure_rank
    return if rank.present?
    self.rank = bot.next_question_rank
  end
end
