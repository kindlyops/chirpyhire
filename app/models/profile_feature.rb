class ProfileFeature < ActiveRecord::Base
  belongs_to :profile
  has_many :user_features

  validates :format, inclusion: { in: %w(document address) }

  def self.stale_for(user)
    where.not(id: user.user_features.pluck(:profile_feature_id))
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
