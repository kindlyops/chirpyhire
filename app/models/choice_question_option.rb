class ChoiceQuestionOption < ApplicationRecord
  has_paper_trail
  belongs_to :question, class_name: "ChoiceQuestion", foreign_key: :question_id, inverse_of: :choice_question_options

  validates :letter, inclusion: { in: [*'a'..'z'] }
end
