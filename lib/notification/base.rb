class Notification::Base
  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact
  delegate :team, :organization, to: :contact

  def recruiter
    team && team.recruiter || organization.recruiter
  end
end
