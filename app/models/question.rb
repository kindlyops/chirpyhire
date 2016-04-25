class Question < ActiveRecord::Base
  has_many :inquiries
  has_many :answers
  has_many :search_questions
  belongs_to :question_template
  belongs_to :organization

  delegate :body, to: :question_template
end
