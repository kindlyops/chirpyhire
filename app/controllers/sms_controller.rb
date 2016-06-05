class SmsController < ActionController::Base
  after_filter :set_header

  protect_from_forgery with: :null_session

  def unknown_chirp
    chirp

    head :ok
  end

  private

  def chirp
    @chirp ||= sender.chirps.create(message: message)
  end

  def message
    @message ||= Message.find_or_initialize_by(sid: params["MessageSid"], direction: "inbound", body: params["Body"])
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
