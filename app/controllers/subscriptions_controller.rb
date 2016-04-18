class SubscriptionsController < SmsController
  def create
    if lead.subscribed?
      render_sms already_subscribed
    else
      subscription = lead.subscribe
      render_sms subscription.sms_response
    end
  end

  def destroy
    if lead.unsubscribed?
      render_sms not_subscribed
    else
      subscription = lead.unsubscribe
      render_sms subscription.sms_response
    end
  end

  private

  def already_subscribed
    Sms::Response.new do |r|
      r.Message "You are already subscribed. Thanks for your interest in #{organization.name}."
    end
  end

  def not_subscribed
    Sms::Response.new do |r|
      r.Message "You were not subscribed. To subscribe reply with CARE."
    end
  end

  def lead
    @lead ||= LeadFinder.new(organization: organization, attributes: attributes).call
  end

  def attributes
    { phone_number: params["From"] }
  end
end
