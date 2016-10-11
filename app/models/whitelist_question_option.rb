class WhitelistQuestionOption < ApplicationRecord
  belongs_to :whitelist_question,
             class_name: 'WhitelistQuestion',
             foreign_key: :question_id,
             inverse_of: :whitelist_question_options
  validates :text, uniqueness: { scope: :question_id }
  validates :text, presence: true
end
