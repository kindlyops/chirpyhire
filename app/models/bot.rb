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
    Bot::Receiver.call(self, message)
  end

  def activated?(message)
    Bot::Keyword.new(self, message).activated?
  end

  def greet(message, campaign_contact)
    Bot::Greet.call(self, message, campaign_contact)
  end

  def question_after(question)
    questions.active.where('rank > ?', question.rank).order(:rank).first
  end

  def first_question
    questions.order(:rank).first
  end

  def last_question
    questions.order(:rank).last
  end

  def first_goal
    goals.order(:rank).first
  end

  def last_goal
    goals.order(:rank).last
  end

  def next_question_rank
    return 1 if last_question.blank?

    last_question.rank + 1
  end

  def next_goal_rank
    return 1 if last_goal.blank?

    last_goal.rank + 1
  end
end
