class SurveyAdvancer
  def self.call(organization)
    new(organization).call
  end

  def initialize(organization)
    @organization = organization
  end

  def call
    organization.candidates.potential.find_each do |candidate|
      advance(candidate) unless candidate.outstanding_inquiry?
    end
  end

  private

  def advance(candidate)
    CandidateAdvancerJob.perform_later(candidate.user)
  end

  attr_reader :organization
end
