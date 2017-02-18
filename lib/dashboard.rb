class Dashboard
  def initialize(organization)
    @organization = organization
  end

  delegate :candidates, to: :organization

  attr_reader :organization
end
