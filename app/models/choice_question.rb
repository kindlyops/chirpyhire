class ChoiceQuestion < Question
  has_many :choice_question_options, foreign_key: :question_id, inverse_of: :question
end
