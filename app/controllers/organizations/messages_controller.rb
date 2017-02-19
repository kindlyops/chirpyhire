class Organizations::MessagesController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :set_header

  def create
    MessageSyncerJob.perform_later(person, organization, params['MessageSid'])

    head :ok
  end

  private

  def subscriber
    person.subscribers.find_or_create_by(organization: organization)
  end

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
