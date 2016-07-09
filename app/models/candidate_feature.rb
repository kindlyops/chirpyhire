class CandidateFeature < ApplicationRecord
  belongs_to :candidate
  belongs_to :persona_feature
  has_many :inquiries

  delegate :name, to: :persona_feature, prefix: true
  delegate :format, to: :persona_feature
  delegate :user, to: :candidate

  def inquire
    message = candidate.receive_message(body: persona_feature.question)
    inquiries.create(message: message)
  end

  def child_class
    properties['child_class'] || "candidate_feature"
  end
end
