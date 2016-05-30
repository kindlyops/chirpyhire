class SmsController < ActionController::Base
  after_filter :set_header

  protect_from_forgery with: :null_session

  def unknown_message
    sender.tasks.create(category: "reply")

    head :ok
  end

  private

  def message
    @message ||= sender.messages.find_or_create_by(sid: params["MessageSid"])
  end

  def vcard
    @vcard ||= Vcard.new(url: params["MediaUrl0"])
  end

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
