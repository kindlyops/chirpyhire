class Organizations::MessagesController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :set_header

  def create
    MessageSyncerJob.perform_later(person, organization, params['MessageSid'])

    head :ok
  end

  private

  def contact
    person.contacts.find_or_create_by(organization: organization)
  end

  def person
    @person ||= begin
      person = Person.find_or_create_by(phone_number: from)
      person.candidacy.update!(phone_number: phone_number)
      person
    end
  end

  def organization
    @organization ||= Organization.find_by(phone_number: params['To'])
  end

  def phone_number
    @phone_number ||= PhoneNumber.find_or_create_by(phone_number: from)
  end

  def from
    params['From']
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end
end
