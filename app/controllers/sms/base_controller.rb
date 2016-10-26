class Sms::BaseController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :set_header

  def unknown_message
    UnknownMessageHandlerJob.perform_later(sender, params['MessageSid'])

    head :ok
  end

  private

  def sender
    @sender ||= begin
    UserFinder.find(
      attributes: { phone_number: params['From'] },
      organization: organization
    )
    end
  end

  def organization
    @organization ||= Organization.find_by(phone_number: params['To'])
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end
end
