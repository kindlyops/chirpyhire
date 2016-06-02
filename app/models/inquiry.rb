class Inquiry < ActiveRecord::Base
  belongs_to :user_feature
  belongs_to :message
  has_one :answer
  delegate :organization, to: :message
  delegate :format, :profile_feature_name, to: :user_feature

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def question_name
    profile_feature_name
  end
end
