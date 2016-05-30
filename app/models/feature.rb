class Feature < ActiveRecord::Base
  belongs_to :profile
  has_many :candidate_features

  validates :format, inclusion: { in: %w(document) }

  def document?
    format == "document"
  end
end
