class Inquiry < ActiveRecord::Base
  belongs_to :question
  belongs_to :message
  has_one :answer

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def expects?(message)
    if question.image?
      message.media_url.present?
    elsif question.text?
      message.body.present?
    end
  end
end
