class Seeder::SeedAccount
  def self.call
    new.call
  end

  def initialize
    @account = Account.create(account_attributes)
  end

  def call
    account.tap do
      organization.update(recruiter: account)
      organization.create_subscription
      setup_team
      setup_zipcodes
    end
  end

  private

  attr_reader :account

  def setup_team
    assignment_rule
    team.accounts << account
    team.update(recruiter: account)
    recruiting_ad
  end

  def setup_zipcodes
    zipcodes.each do |zipcode|
      FactoryGirl.create(:zipcode, zipcode.to_sym)
    end
  end

  def zipcodes
    %w[30319 30324 30327 30328 30329
       30338 30339 30340 30341 30342]
  end

  def organization
    @organization ||= account.organization
  end

  def team
    @team ||= organization.teams.first
  end

  def inbox
    @inbox ||= team.create_inbox
  end

  def phone_number
    @phone_number ||= begin
      organization.phone_numbers.create(
        sid: ENV.fetch('DEMO_ORGANIZATION_PHONE_SID'),
        phone_number: ENV.fetch('DEMO_ORGANIZATION_PHONE')
      )
    end
  end

  def assignment_rule
    @assignment_rule ||= begin
      organization.assignment_rules.create(
        inbox: inbox, phone_number: phone_number
      )
    end
  end

  def recruiting_ad
    @recruiting_ad ||= begin
      organization.create_recruiting_ad(
        team: team, body: RecruitingAd.body(team, phone_number)
      )
    end
  end

  def account_attributes
    {
      password: ENV.fetch('DEMO_PASSWORD'),
      person_attributes: { name: ENV.fetch('DEMO_NAME') },
      email: ENV.fetch('DEMO_EMAIL'),
      super_admin: true,
      organization_attributes: organization_attributes
    }
  end

  def organization_attributes
    {
      name: ENV.fetch('DEMO_ORGANIZATION_NAME'),
      twilio_account_sid: ENV.fetch('DEMO_TWILIO_ACCOUNT_SID'),
      twilio_auth_token: ENV.fetch('DEMO_TWILIO_AUTH_TOKEN'),
      teams_attributes: {
        '0' => team_params
      }
    }
  end

  def team_attributes
    { name: 'Atlanta' }
  end

  def team_params
    team_attributes.merge(location_attributes: location_attributes)
  end

  def full_street_address
    '2225 Spring Walk Court, Chamblee, GA 30341, United States of America'
  end

  def location_attributes
    { latitude: 33.912779, longitude: -84.2975454,
      full_street_address: full_street_address,
      city: 'Chamblee', state: 'Georgia', state_code: 'GA',
      postal_code: '30341', country: 'United States of America',
      country_code: 'us' }
  end
end
