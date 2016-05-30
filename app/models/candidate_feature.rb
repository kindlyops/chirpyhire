class CandidateFeature < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :profile_feature
  has_many :inquiries

  delegate :document?, to: :profile_feature
  delegate :format, to: :profile_feature, prefix: true

  def inquire
    message = candidate.receive_message(body: body)
    inquiries.create(message: message)
  end

  def body
    "Please send a photo of your #{profile_feature.name}" if document?
  end
end
