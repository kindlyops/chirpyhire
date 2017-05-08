class Brokers::BaseController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :set_header

  def create
    BrokerMessageSyncerJob.perform_later(broker_contact, params['MessageSid'])

    head :ok
  end

  private

  def broker_contact
    @broker_contact ||= begin
      broker_contact = person.broker_contacts.find_by(broker: broker)
      return broker_contact if broker_contact.present?
      create_subscribed_broker_contact
    end
  end

  def person
    @person ||= begin
      person = Person.find_or_create_by(phone_number: params['From'])
      person.candidacy || person.create_candidacy
      person
    end
  end

  def broker
    Broker.find_by(phone_number: params['To'])
  end

  def create_subscribed_broker_contact
    person.broker_contacts.create(broker: broker).tap(&:subscribe)
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end
end
