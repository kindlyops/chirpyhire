class Organizations::MessagesController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :set_header

  def create
    MessageSyncerJob.perform_later(
      person,
      organization,
      params['MessageSid'],
      receipt: true
    )

    head :ok
  end

  private

  def person
    @person ||= begin
      person = Person.find_or_create_by(phone_number: params['From'])
      person.candidacy || person.create_candidacy
      person
    end
  end

  def organization
    @organization ||= Organization.find_by(phone_number: params['To'])
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end
end
