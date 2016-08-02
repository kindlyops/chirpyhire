class ChoiceQuestionOption < ApplicationRecord
  belongs_to :question, class_name: "ChoiceQuestion", foreign_key: :question_id, inverse_of: :choice_question_options
end
