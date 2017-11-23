class RecruitingAd < ApplicationRecord
  belongs_to :team
  belongs_to :organization, optional: true

  delegate :name, to: :team, prefix: true

  def organization
    super || team.organization
  end

  def self.body(team, phone_number)
    <<~BODY
      #{team.organization_name} is hiring! Our employees are as important to us as our clients. Openings PT/FT for M-F day shifts and weekends.

      *********************************

      For immediate opportunities, text START to #{phone_number.phone_number.phony_formatted}.

      *********************************

      Contact us to discuss our competitive wages, continuing education program and flexible scheduling opportunities.
    BODY
  end
end
