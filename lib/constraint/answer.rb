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
    person.subscribed_to(team)
  end

  def contact_present?
    communicators_present? && person.subscribed_to?(team)
  end

  def communicators_present?
    team.present? && person.present?
  end

  def team
    phone_number.assignment_rule.team
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
