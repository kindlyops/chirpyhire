class ReferrerFinder
  def initialize(organization:, sender:)
    @sender = sender
    @organization = organization
  end

  def call
    referrers.find_by(user: sender)
  end

  private

  attr_reader :sender, :organization

  def referrers
    organization.referrers
  end
end
