class BillingEvent::Subscription
  def call(event)
    subscription = Subscription.find_by(stripe_id: event.data.object.id)

    return update(subscription, event) if subscription.present?
    create(event)
  end

  def create(event)
    customer = fetch_customer(event)
    subscription = customer.subscription || customer.build_subscription
    update(subscription, event)
  end

  def update(subscription, event)
    %i[object application_fee_percent billing cancel_at_period_end
       canceled_at created current_period_end current_period_start customer
       discount ended_at items livemode metadata plan quantity
       start status tax_percent trial_end trial_start].each do |attribute|
      value = event.data.object.send(attribute)
      subscription.send(:write_attribute, attribute, value)
    end
    
    subscription.save
  end

  def fetch_customer(event)
    Organization.find_by(stripe_id: event.data.object.customer)
  end
end
