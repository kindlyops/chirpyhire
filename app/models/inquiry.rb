class Inquiry < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_one :answer
  delegate :organization, to: :user

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def expects?(answer)
    if question.image?
      answer.has_images?
    elsif question.text?
      answer.body.present?
    end
  end
end
