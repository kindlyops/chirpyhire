class SurveyAdvancer
  def self.call(organization)
    new(organization).call
  end

  def initialize(organization)
    @organization = organization
  end

  def call
    potential_candidates.find_each do |candidate|
      unless candidate.outstanding_inquiry?
        CandidateAdvancerJob.perform_later(candidate.user)
      end
    end
  end

  private

  attr_reader :organization

  def potential_candidates
    @potential_candidates ||= organization.candidates.where(status: 'Potential')
  end
end
