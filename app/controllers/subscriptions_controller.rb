class SubscriptionsController < SmsController
  def create
    render_sms subscription.sms_response
  end

  private

  def subscription
    lead.subscribe
  end

  def lead
    @lead ||= LeadFinder.new(organization: organization, attributes: attributes).call
  end

  def attributes
    { phone_number: params["From"] }
  end
end
