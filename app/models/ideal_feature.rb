class IdealFeature < ActiveRecord::Base
  belongs_to :ideal_profile
  has_many :candidate_features

  validates :format, inclusion: { in: %w(document address) }

  def self.next_for(candidate)
    where.not(id: candidate.features.pluck(:ideal_feature_id)).first
  end

  def question
    questions[format.to_sym]
  end

  private

  def questions
    {
      document: "Please send a photo of your #{name}",
      address: "What is your street address and zipcode?"
    }
  end
end
