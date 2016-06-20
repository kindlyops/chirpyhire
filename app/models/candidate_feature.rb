class CandidateFeature < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :persona_feature
  has_many :inquiries

  delegate :name, to: :persona_feature, prefix: true
  delegate :format, to: :persona_feature
  delegate :user, to: :candidate

  def inquire
    message = candidate.receive_message(body: persona_feature.question)
    inquiries.create(user: user, message_attributes: { sid: message.sid, direction: message.direction, body: message.body })
  end

  def child_class
    properties['child_class'] || "candidate_feature"
  end
end
