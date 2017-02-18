class Seeder
  def seed
    seed_plan
    seed_organization
    seed_dev_account
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

    organization.create_subscription(plan: plan, trial_message_limit: 1000)
    organization.create_ideal_candidate!(
      zip_codes_attributes: [{ value: organization.zip_code }]
    )
    puts 'Created Organization'
  end

  def find_or_create_organization
    Organization.find_or_create_by!(
      name: 'Happy Home Care',
      twilio_account_sid: ENV.fetch('TWILIO_ACCOUNT_SID'),
      twilio_auth_token: ENV.fetch('TWILIO_AUTH_TOKEN'),
      phone_number: ENV.fetch('TEST_ORG_PHONE'),
      stripe_customer_id: ENV.fetch('TEST_STRIPE_CUSTOMER_ID'),
      zip_code: '30342'
    )
  end

  def seed_dev_account
    unless organization.accounts.present?
      organization.accounts.create!(
        password: 'password',
        email: ENV.fetch('DEV_EMAIL'),
        super_admin: true
      )
    end

    puts 'Created Account'
  end
end
