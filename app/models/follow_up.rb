class FollowUp < ApplicationRecord
  belongs_to :question

  has_many :follow_ups_tags
  has_many :tags, through: :follow_ups_tags

  belongs_to :next_question, optional: true, class_name: 'Question'
  belongs_to :goal, optional: true

  enum action: {
    next_question: 0, question: 1, goal: 2
  }
end
