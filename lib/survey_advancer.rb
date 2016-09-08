class SurveyAdvancer

  def self.call(organization)
    new(organization).call
  end

  def initialize(organization)
    @organization = organization
  end

  def call
    potential_candidates.find_each do |candidate|
      CandidateAdvancerJob.perform_later(candidate.user) unless candidate.has_outstanding_inquiry?
    end
  end

  private

  attr_reader :organization

  def potential_candidates
    @potential_candidates ||= organization.candidates.where(status: "Potential")
  end
end
