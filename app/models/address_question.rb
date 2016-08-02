class AddressQuestion < Question
  has_one :address_question_option, foreign_key: :question_id, inverse_of: :question
end
