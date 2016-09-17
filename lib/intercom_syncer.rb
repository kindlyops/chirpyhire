# frozen_string_literal: true
class IntercomSyncer
  def initialize(organization)
    @organization = organization
  end

  attr_reader :organization

  def call
    $intercom.companies.create(
      company_id: organization.id,
      name: organization.name,
      plan: organization.plan_name,
      monthly_spend: organization.subscription_price,
      custom_attributes: {
        candidates_count: organization.candidates.count,
        qualified_candidates_count: organization.candidates.qualified.count,
        hired_candidates_count: organization.candidates.hired.count,
        bad_fit_candidates_count: organization.candidates.bad_fit.count,
        trial_percentage_remaining: organization.trial_percentage_remaining,
        trail_remaining_messages_count: organization.trial_remaining_messages_count,
        subscription_state: organization.subscription_state,
        phone_number: organization.decorate.phone_number,
        base_paid_plan_price: Plan::DEFAULT_PRICE_IN_DOLLARS,
        base_paid_plan_message_limit: Plan.messages_per_quantity
      }
    )
  end
end
