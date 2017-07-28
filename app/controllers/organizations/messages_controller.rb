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
      contact = organization.contacts.find_by(phone_number: params['From'])
      contact || create_subscribed_contact
    end
  end

  def phone_number
    @phone_number ||= PhoneNumber.find_by(phone_number: params['To'])
  end

  def create_subscribed_contact
    organization.contacts.create(contact_params).tap(&:subscribe)
  end

  def contact_params
    {
      stage: stage,
      person: Person.create(phone_number: params['From']),
      phone_number: params['From']
    }
  end

  def stage
    organization.contact_stages.first
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end

  delegate :organization, to: :phone_number
end
