class CandidateFeature < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :feature
  has_many :inquiries

  delegate :document?, to: :feature
  delegate :format, to: :feature, prefix: true

  def inquire
    message = candidate.receive_message(body: body)
    inquiries.create(message: message)
  end

  def body
    "Please send a photo of your #{feature.name}" if document?
  end
end
