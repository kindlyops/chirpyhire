class Bot < ApplicationRecord
  belongs_to :organization
  belongs_to :person
  belongs_to :last_edited_by, optional: true, class_name: 'Account'

  has_one :greeting
  has_many :questions
  has_many :ranked_questions, -> { ranked }, class_name: 'Question'
  has_many :goals
  has_many :ranked_goals, -> { ranked }, class_name: 'Goal'

  has_many :bot_campaigns
  has_many :inboxes, through: :bot_campaigns
  has_many :campaigns, through: :bot_campaigns
  has_many :actions, class_name: 'BotAction'

  accepts_nested_attributes_for :greeting
  accepts_nested_attributes_for :questions
  accepts_nested_attributes_for :goals

  validates :goals, presence: true, on: :update
  validates :questions, presence: true, on: :update
  validates :name, presence: true

  def self.recent
    order(created_at: :desc)
  end

  def receive(message)
    Bot::Receiver.call(self, message)
  end

  def activated?(message)
    Bot::Keyword.new(self, message).activated?
  end

  def greet(message, campaign_contact)
    Bot::Greet.call(self, message, campaign_contact)
  end

  def question_after(question)
    ranked_questions.active.find_by('rank > ?', question.rank)
  end

  def first_active_question
    ranked_questions.active.first
  end

  def last_question
    ranked_questions.last
  end

  def first_goal
    ranked_goals.first
  end

  def last_goal
    ranked_goals.last
  end

  def next_question_rank
    return 1 if last_question.blank?

    last_question.rank + 1
  end

  def next_goal_rank
    return 1 if last_goal.blank?

    last_goal.rank + 1
  end

  def next_question_action
    actions.find_by(type: 'NextQuestionAction')
  end
end
