class SubscriptionsController < SmsController
  def create
    if sender.subscribed_to?(organization)
      render_sms already_subscribed
    else
      ensure_lead_exists

      subscription = sender.subscribe_to(organization)
      render_sms subscription_notice
    end
  end

  def destroy
    if sender.unsubscribed_from?(organization)
      render_sms not_subscribed
    else
      sender.unsubscribe_from(organization)
      render_sms unsubscribed_notice
    end
  end

  private

  def ensure_lead_exists
    organization.leads.find_or_create_by(user: sender)
  end

  def subscription_notice
    Sms::Response.new do |r|
      r.Message "#{sender.first_name}, this is #{organization.owner_first_name} \
at #{organization.name}. I'm so glad you are interested in learning about \
opportunities here. When we have a need we'll send out a few text messages \
asking you questions about your availability and experience. If you ever wish \
to stop receiving text messages just reply STOP. Thanks again for your interest!"
    end
  end

  def unsubscribed_notice
    Sms::Response.new do |r|
      r.Message "You are unsubscribed. To subscribe reply with START. Thanks for your interest in #{organization.name}."
    end
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
