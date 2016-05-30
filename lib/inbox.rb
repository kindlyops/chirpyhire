class Inbox
  def initialize(organization:)
    @organization = organization
  end

  def tasks
    organization.tasks.outstanding
  end

  private

  attr_reader :organization
end
