class Registrar
  def initialize(account)
    @account = account
  end

  def register
    Organization.transaction do
      # Seed example candidate
      create_ideal_candidate
      create_subscription
      # TwilioProvisionerJob.perform_later(organization)
    end
  end

  private

  attr_reader :account

  def create_ideal_candidate
    organization.create_ideal_candidate!(
      zip_codes_attributes: [{value: organization.zip_code}]
    )
  end

  def create_subscription
    organization.create_subscription!(
      plan: plan,
      state: 'trialing',
      trial_message_limit: Plan::TRIAL_MESSAGE_LIMIT
    )
  end

  def organization
    @organization ||= account.organization
  end

  def plan
    Plan.first || create_plan
  end

  def create_plan
    Plan.create!(
      amount: Plan::DEFAULT_PRICE_IN_DOLLARS * 100,
      interval: 'month',
      stripe_id: ENV.fetch("TEST_STRIPE_PLAN_ID", "1"), name: 'Basic'
    )
  end
end
