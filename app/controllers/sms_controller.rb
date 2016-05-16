class SmsController < ActionController::Base
  after_filter :set_header

  protect_from_forgery with: :null_session

  def invalid_message
    sender

    head :ok
  end

  private

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

  def render_sms(sms)
    render text: sms.text
  end
end
