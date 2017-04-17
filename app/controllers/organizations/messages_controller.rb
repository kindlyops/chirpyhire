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
    @person ||= candidacy.person || candidacy.create_person
  end

  def candidacy
    @candidacy ||= Candidacy.find_or_create_by(phone_number: phone_number)
  end

  def organization
    @organization ||= Organization.find_by(phone_number: params['To'])
  end

  def phone_number
    @phone_number ||= begin
      PhoneNumber.find_or_create_by(phone_number: params['From'])
    end
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end
end
