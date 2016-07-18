class CandidatePersona < ApplicationRecord
  belongs_to :organization
  has_many :persona_features
  belongs_to :actionable, class_name: "CandidatePersonaActionable", foreign_key: :actionable_id, inverse_of: :candidate_persona
  belongs_to :template

  def perform(user)
    ProfileAdvancer.call(user)
  end

  private

  def set_template
    create_template(organization: organization,
                    name: "Bad Fit Message - Default",
                    body: "Thank you very much for your interest. Unfortunately, we don't have a good fit for you at this time. If anything changes we will let you know.")
  end
end
