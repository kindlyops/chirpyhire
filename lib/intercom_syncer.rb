class IntercomSyncer
  def initialize(organization)
    @organization = organization
  end

  attr_reader :organization

  def call
    communicator.companies.create(
      company_id: organization.id,
      name: organization.name,
      plan: organization.plan_name,
      monthly_spend: organization.subscription_price,
      custom_attributes: custom_attributes
    )
  end

  delegate :trial_remaining_messages_count, :candidates, to: :organization

  private

  def custom_attributes
    {
      subscription_state: organization.subscription_state,
      phone_number: organization.decorate.phone_number,
      base_paid_plan_price: Plan::DEFAULT_PRICE_IN_DOLLARS,
      base_paid_plan_message_limit: Plan.messages_per_quantity,
      trial_percentage_remaining: organization.trial_percentage_remaining
    }.merge(counts)
  end

  def counts
    {
      candidates_count: candidates.count,
      qualified_candidates_count: candidates.qualified.count,
      hired_candidates_count: candidates.hired.count,
      bad_fit_candidates_count: candidates.bad_fit.count,
      trail_remaining_messages_count: trial_remaining_messages_count
    }
  end

  def communicator
    CustomerCommunicator.instance.client
  end
end
