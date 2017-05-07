class Organizations::MessagesController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :set_header

  def create
    MessageSyncerJob.perform_later(contact, params['MessageSid'], receipt: true)

    head :ok
  end

  private

  def contact
    @contact ||= begin
      contact = person.contacts.find_by(organization: organization)
      return contact if contact.present?
      create_subscribed_contact
    end
  end

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

  def create_subscribed_contact
    person.contacts.create(organization: organization).tap do |contact|
      contact.subscribe
      IceBreakerJob.perform_later(contact)
    end
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end
end