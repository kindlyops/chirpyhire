class Notification::Base
  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact
  delegate :team, to: :contact
  delegate :recruiter, :organization, to: :team
end
