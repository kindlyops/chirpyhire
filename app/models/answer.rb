class Answer < ApplicationRecord
  include Messageable
  belongs_to :inquiry
  delegate :question_name, :persona_feature, to: :inquiry

  validate do |answer|
    AnswerValidator.new(answer).validate
  end
end
