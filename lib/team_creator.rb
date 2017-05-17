class TeamCreator
  def self.call(organization)
    new(organization).call
  end

  def initialize(organization)
    @organization = organization
  end

  def call
    return teams.first unless teams.empty?

    setup_team
  end

  private

  attr_reader :organization

  delegate :location, :teams, :recruiting_ad, to: :organization

  def setup_team
    location.update(team: team)
    recruiting_ad.update(team: team)
    team.accounts << account
    team
  end

  def account
    organization.accounts.first
  end

  def team
    @team ||= begin
      organization.teams.create(
        phone_number: organization.phone_number,
        name: location.city,
        recruiter: account
      )
    end
  end
end
