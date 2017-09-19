class BillingEvent::Subscription
  def call(event)
    subscription = ::Subscription.find_by(stripe_id: event.data.object.id)

    return update(subscription, event.data.object) if subscription.present?
    create(event.data.object)
  end

  def create(stripe_object)
    customer = ::Organization.find_by(stripe_id: stripe_object.customer)
    subscription = customer.subscription || customer.build_subscription
    subscription.stripe_id = stripe_object.id
    update(subscription, stripe_object)
  end

  def update(subscription, stripe_object)
    %i[object application_fee_percent billing cancel_at_period_end
       canceled_at created current_period_end current_period_start customer
       discount ended_at items livemode metadata plan quantity
       start status tax_percent trial_end trial_start].each do |attribute|
      value = stripe_object.send(attribute)
      subscription.send(:write_attribute, attribute, value)
    end

    subscription.save
  end
end
