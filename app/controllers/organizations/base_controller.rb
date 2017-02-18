class Organizations::BaseController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :set_header

  def unsolicited_message
    UnsolicitedMessageHandlerJob.perform_later(person, params['MessageSid'])

    head :ok
  end

  private

  def person
    @person ||= Person.find_or_create_by(phone_number: params['From'])
  end

  def organization
    @organization ||= Organization.find_by(phone_number: params['To'])
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end
end
