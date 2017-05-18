class TeamFindOrCreator
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
        recruiter: account,
        location_attributes: location_attributes
      )
    end
  end

  def location_attributes
    location_keys.each_with_object({}) do |key, hash|
      hash[key] = location.send(key)
    end
  end

  def location_keys
    %i(full_street_address
       latitude
       longitude
       city
       state
       state_code
       postal_code
       country
       country_code)
  end
end
