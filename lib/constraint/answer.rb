class Constraint::Answer < Constraint::Base
  def matches?(request)
    @request = request
    surveying_subscriber? && candidacy.inquiry.present?
  end

  private

  def surveying_subscriber?
    subscriber_present? && same_subscriber?
  end

  def same_subscriber?
    person.subscribed_to(organization) == candidacy.subscriber
  end

  delegate :candidacy, to: :person

  def subscriber_present?
    communicators_present? && person.subscribed_to?(organization)
  end

  def communicators_present?
    organization.present? && person.present?
  end

  def organization
    Organization.find_by(phone_number: to)
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
