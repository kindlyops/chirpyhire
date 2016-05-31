class ProfileFeature < ActiveRecord::Base
  belongs_to :profile
  has_many :candidate_features

  validates :format, inclusion: { in: %w(document) }

  def document?
    format == "document"
  end

  def self.stale_for(candidate)
    joins("LEFT OUTER JOIN candidate_features ON candidate_features.profile_feature_id=profile_features.id").where("candidate_features.id IS NULL")
  end
end
