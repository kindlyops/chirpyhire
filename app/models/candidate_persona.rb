class CandidatePersona < ApplicationRecord
  belongs_to :organization
  has_many :persona_features
  belongs_to :actionable, class_name: "CandidatePersonaActionable", foreign_key: :actionable_id, inverse_of: :candidate_persona
  belongs_to :template

  def perform(user)
    ProfileAdvancer.call(user)
  end

  def template
    super || set_template
  end

  private

  def set_template
    create_template(organization: organization,
                    name: "Bad Fit Message - Default",
                    body: "Thanks for your interest. Unfortunately, we don't have a good fit for you at this time but will reach out if anything changes.")
  end
end
