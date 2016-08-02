class Survey < ApplicationRecord
  belongs_to :organization
  belongs_to :template
  belongs_to :actionable, class_name: "SurveyActionable", foreign_key: :actionable_id, inverse_of: :survey
  has_many :questions

  def perform(user)
    ProfileAdvancer.call(user)
  end
end
