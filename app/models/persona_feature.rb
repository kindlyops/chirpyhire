class PersonaFeature < ActiveRecord::Base
  belongs_to :candidate_persona
  has_many :candidate_features

  validates :format, inclusion: { in: %w(document address) }

  def self.next_for(candidate)
    where.not(id: candidate.features.pluck(:persona_feature_id)).first
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
