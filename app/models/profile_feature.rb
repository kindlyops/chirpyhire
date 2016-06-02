class ProfileFeature < ActiveRecord::Base
  belongs_to :profile
  has_many :user_features

  validates :format, inclusion: { in: %w(document) }

  def document?
    format == "document"
  end

  def self.stale
    joins("LEFT OUTER JOIN user_features ON user_features.profile_feature_id=profile_features.id").where("user_features.id IS NULL")
  end
end
