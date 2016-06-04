class Inquiry < ActiveRecord::Base
  belongs_to :user_feature
  has_one :message, as: :messageable
  has_one :answer
  delegate :organization, to: :message
  delegate :format, :profile_feature_name, to: :user_feature
  accepts_nested_attributes_for :message

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def question_name
    profile_feature_name
  end
end
