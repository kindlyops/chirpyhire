class SubscriptionsController < SmsController
  before_action :message, only: [:create, :destroy]

  def create
    if candidate.subscribed?
      render_sms already_subscribed
    else
      candidate.subscribe
      AutomatonJob.perform_later(candidate, candidate.subscription, "subscribe")
      render_sms subscription_notice
    end
  end

  def destroy
    if candidate.unsubscribed?
      render_sms not_subscribed
    else
      candidate.unsubscribe
      render_sms unsubscribed_notice
    end
  end

  private

  def candidate
    @candidate ||= begin
      return user.candidate if user.candidate.present?
      user.create_candidate
    end
  end

  def sender
    candidate
  end

  def user
    @user ||= organization.users.find_or_create_by(phone_number: params["From"])
  end

  def subscription_notice
    Sms::Response.new do |r|
      r.Message "If you ever wish \
to stop receiving text messages just reply STOP."
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
