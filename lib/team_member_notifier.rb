class TeamMemberNotifier
  def self.call(member)
    new(member).call
  end

  def initialize(member)
    @member = member
  end

  attr_reader :member

  def call
    NotificationMailer.added_to_team(member).deliver_later(wait: 5.minutes)
  end
end
