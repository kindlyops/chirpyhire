class Constraint::ConstraintBase
  attr_reader :request

  delegate :outstanding_inquiry, to: :user

  def candidate_present?
    organization.present? && user&.candidate.present?
  end

  def cleaned_request_body
    clean(body)
  end

  def user
    organization.users.find_by(phone_number: from)
  end

  def organization
    Organization.find_by(phone_number: to)
  end

  def to
    request.request_parameters['To']
  end

  def from
    request.request_parameters['From']
  end

  def body
    request.request_parameters['Body']
  end

  def clean(string)
    remove_non_alphanumerics(string).strip.upcase
  end

  def remove_non_alphanumerics(string)
    string.gsub(/[^a-z0-9\s]/i, '')
  end
end
