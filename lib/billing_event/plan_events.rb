class BillingEvent::PlanEvents
  def call(event)
    plan = Plan.find_by(stripe_id: event.data.object.id)

    return update(plan, event.data.object) if plan.present?
    create(event.data.object)
  end

  def create(stripe_object)
    plan = Plan.new(stripe_id: stripe_object.id)
    update(plan, stripe_object)
  end

  def update(plan, stripe_object)
    %i[object amount created currency interval interval_count livemode metadata
       name statement_descriptor trial_period_days].each do |attribute|
      value = stripe_object.send(attribute)
      plan.send(:write_attribute, attribute, value)
    end

    plan.save
  end
end
