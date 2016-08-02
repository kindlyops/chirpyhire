class AddressQuestionOption < ApplicationRecord
  belongs_to :question, class_name: "AddressQuestion", foreign_key: :question_id, inverse_of: :address_question_option
end
