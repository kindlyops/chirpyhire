class SmsController < ActionController::Base
  after_action :set_header

  protect_from_forgery with: :null_session

  def unknown_chirp
    UnknownChirpHandlerJob.perform_later(sender, params["MessageSid"])

    head :ok
  end

  private

  def sender
    @sender ||= UserFinder.new(attributes: {phone_number: params["From"]}, organization: organization).call
  end

  def organization
    @organization ||= Organization.for(phone: params["To"])
  end

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end
end
