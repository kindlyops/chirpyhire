class Inquiry < ActiveRecord::Base
  belongs_to :question
  belongs_to :message
  has_one :answer
  delegate :organization, to: :message

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def perform(user, answer)
    message = user.messages.create(body: answer[:body], sid: answer[:sid])
    create_answer(message: message)
  end

  def expects?(answer)
    if question.image?
      answer.has_images?
    elsif question.text?
      answer.body.present?
    end
  end
end
