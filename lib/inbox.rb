class Inbox
  def initialize(organization:)
    @organization = organization
  end

  def tasks
    organization.tasks.incomplete
  end

  private

  attr_reader :organization
end
