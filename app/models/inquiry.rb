class Inquiry < ActiveRecord::Base
  belongs_to :candidate_feature
  belongs_to :user

  has_one :message, as: :messageable
  has_one :answer

  delegate :organization, to: :user
  delegate :format, :ideal_feature_name, to: :candidate_feature
  accepts_nested_attributes_for :message

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def question_name
    ideal_feature_name
  end
end
