class Registrar
  def initialize(account)
    @account = account
  end

  def register
    Organization.transaction do
      organization.update(recruiter: account)
      create_ideal_candidate
      create_recruiting_ad
      create_subscription
      PhoneNumberProvisionerJob.perform_later(organization)
    end
  end

  private

  attr_reader :account

  def create_ideal_candidate
    organization.create_ideal_candidate!(
      zipcodes_attributes: [{ value: organization.zipcode }]
    )
  end

  def create_recruiting_ad
    organization.create_recruiting_ad!(body: RecruitingAd.body(organization))
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
      stripe_id: ENV.fetch('TEST_STRIPE_PLAN_ID', '1'), name: 'Basic'
    )
  end
end
