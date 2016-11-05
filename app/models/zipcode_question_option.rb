class ZipcodeQuestionOption < ApplicationRecord
  belongs_to :zipcode_question,
             class_name: 'ZipcodeQuestion',
             foreign_key: :question_id,
             inverse_of: :zipcode_question_options
  validates :text, uniqueness: { scope: :question_id }
  validates :text, presence: true
end
