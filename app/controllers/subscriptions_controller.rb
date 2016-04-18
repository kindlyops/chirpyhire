class SubscriptionsController < SmsController
  def create
    if sender.subscribed_to?(organization)
      render_sms already_subscribed
    else
      ensure_lead_exists

      subscription = sender.subscribe_to(organization)
      render_sms subscription.sms_response
    end
  end

  def destroy
    if sender.unsubscribed_from?(organization)
      render_sms not_subscribed
    else
      subscription = sender.unsubscribe_from(organization)
      render_sms subscription.sms_response
    end
  end

  private

  def ensure_lead_exists
    organization.leads.find_or_create_by(user: sender)
  end

  def already_subscribed
    Sms::Response.new do |r|
      r.Message "You are already subscribed. Thanks for your interest in #{organization.name}."
    end
  end

  def not_subscribed
    Sms::Response.new do |r|
      r.Message "You were not subscribed. To subscribe reply with START."
    end
  end
end
