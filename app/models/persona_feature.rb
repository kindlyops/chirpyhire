class PersonaFeature < ApplicationRecord
  belongs_to :candidate_persona
  belongs_to :category
  has_many :inquiries

  validates :format, inclusion: { in: %w(document address choice) }
  delegate :template, to: :candidate_persona
  delegate :name, to: :category, prefix: true

  def question
    text
  end

  def inquire(user)
    message = user.receive_message(body: question)
    inquiries.create(message: message)
  end
end
