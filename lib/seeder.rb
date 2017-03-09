class Seeder
  def seed
    seed_plan
    seed_organization
    seed_account
    seed_incomplete_contacts
    seed_complete_contacts
  end

  private

  attr_reader :plan, :organization, :account

  def seed_plan
    @plan = Plan.first || create_plan

    puts 'Created Plan'
  end

  def create_plan
    Plan.create(
      amount: Plan::DEFAULT_PRICE_IN_DOLLARS * 100,
      interval: 'month',
      stripe_id: ENV.fetch('TEST_STRIPE_PLAN_ID', '1'),
      name: 'Basic'
    )
  end

  def seed_organization
    @organization = find_or_create_organization
    seed_location
    organization.create_subscription(plan: plan, trial_message_limit: 1000)
    organization.create_ideal_candidate!(
      zipcodes_attributes: [{ value: '30341' }]
    )
    puts 'Created Organization'
  end

  def seed_location
    organization.location || organization.create_location(
      latitude: 33.912779, longitude: -84.2975454,
      full_street_address: full_street_address,
      city: 'Chamblee', state: 'GA', state_code: 'GA',
      postal_code: '30341', country: 'United States of America',
      country_code: 'us'
    )
  end

  def full_street_address
    '2225 Spring Walk Court, Chamblee, GA 30341, United States of America'
  end

  def find_or_create_organization
    Organization.find_or_create_by!(
      name: 'Happy Home Care',
      twilio_account_sid: ENV.fetch('TWILIO_ACCOUNT_SID'),
      twilio_auth_token: ENV.fetch('TWILIO_AUTH_TOKEN'),
      phone_number: ENV.fetch('DEMO_ORG_PHONE')
    )
  end

  def seed_account
    unless organization.accounts.present?
      organization.accounts.create!(
        password: ENV.fetch('DEMO_PASSWORD'),
        email: ENV.fetch('DEMO_EMAIL'),
        super_admin: true
      )
    end

    puts 'Created Account'
  end
end
