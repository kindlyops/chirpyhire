class Inquiry < ApplicationRecord
  belongs_to :candidacy
  belongs_to :message
  has_one :answer

  def self.unanswered
    includes(:answer).where(answers: { inquiry_id: nil })
  end
end
