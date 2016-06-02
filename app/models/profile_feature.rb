class ProfileFeature < ActiveRecord::Base
  belongs_to :profile
  has_many :user_features

  validates :format, inclusion: { in: %w(document address) }

  def self.stale
    joins("LEFT OUTER JOIN user_features ON user_features.profile_feature_id = profile_features.id").where("user_features.id IS NULL")
  end

  def question
    questions[format.to_sym]
  end

  def questions
    {
      document: "Please send a photo of your #{name}",
      address: "What is your street address and zipcode?"
    }
  end
end
