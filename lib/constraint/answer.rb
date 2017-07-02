class Constraint::Answer < Constraint::Base
  def matches?(request)
    @request = request
    surveying_contact? && candidacy.inquiry.present?
  end

  private

  def surveying_contact?
    contact_present?
  end

  def candidacy
    contact.contact_candidacy
  end

  def contact
    person.subscribed_to(organization)
  end

  def contact_present?
    communicators_present? && person.subscribed_to?(organization)
  end

  def communicators_present?
    organization.present? && person.present?
  end

  def organization
    phone_number.organization
  end

  def phone_number
    PhoneNumber.find_by(phone_number: to)
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
