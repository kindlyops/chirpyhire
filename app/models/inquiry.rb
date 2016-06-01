class Inquiry < ActiveRecord::Base
  belongs_to :candidate_feature
  belongs_to :message
  has_one :answer
  delegate :organization, to: :message
  delegate :profile_feature_format, :profile_feature_name, to: :candidate_feature

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def expects?(answer)
    if candidate_feature.document?
      answer.has_images?
    end
  end

  def question_name
    profile_feature_name
  end
end
