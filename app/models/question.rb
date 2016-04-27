class Question < ActiveRecord::Base
  has_many :inquiries
  has_many :answers
  has_many :job_questions
  belongs_to :question_template
  belongs_to :organization

  delegate :body, :title, :category, to: :question_template
end
