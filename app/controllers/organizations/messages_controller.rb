class Organizations::MessagesController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :set_header

  def create
    DeliveryAgentJob.perform_later(contact, params['MessageSid'])

    head :ok
  end

  private

  def contact
    @contact ||= begin
      contact = person.contacts.find_by(organization: organization)
      contact || create_subscribed_contact
    end
  end

  def person
    @person ||= Person.find_or_create_by(phone_number: params['From'])
  end

  def phone_number
    @phone_number ||= PhoneNumber.find_by(phone_number: params['To'])
  end

  def create_subscribed_contact
    person.contacts.create(organization: organization).tap do |contact|
      contact.subscribe
      contact.create_contact_candidacy
    end
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end

  delegate :organization, to: :phone_number
end
