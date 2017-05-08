class Constraint::Broker::Answer < Constraint::Base
  def matches?(request)
    @request = request
    surveying_broker_contact? && broker_candidacy.inquiry.present?
  end

  private

  def surveying_broker_contact?
    broker_contact_present? && same_broker_contact?
  end

  def same_broker_contact?
    person.broker_subscribed_to(broker) == broker_candidacy.broker_contact
  end

  delegate :broker_candidacy, to: :person

  def broker_contact_present?
    communicators_present? && person.broker_subscribed_to?(broker)
  end

  def communicators_present?
    broker.present? && person.present?
  end

  def broker
    Broker.find_by(phone_number: to)
  end

  def person
    Person.find_by(phone_number: from)
  end

  def to
    request.request_parameters['To']
  end

  def from
    request.request_parameters['From']
  end
end
