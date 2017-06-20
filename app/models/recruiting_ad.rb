class RecruitingAd < ApplicationRecord
  belongs_to :team
  belongs_to :organization, optional: true

  delegate :name, to: :team, prefix: true

  def organization
    super || team.organization
  end

  def self.body(team)
    <<~BODY
      #{team.organization_name} is hiring Caregivers! Our CNAs are as important to us as our clients. Openings PT/FT for M-F day shifts and weekends.

      *********************************

      For immediate opportunities, text START to #{team.phone_number.phony_formatted}.

      *********************************

      If you are passionate about helping the elderly remain safe and comfortable at home, enjoy working independently and are seeking a personal challenge, contact us to discuss our competitive wages, continuing education program and flexible scheduling opportunities.
    BODY
  end
end
