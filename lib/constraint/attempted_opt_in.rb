class Constraint::AttemptedOptIn
  include Constraint::ConstraintHelper

  def matches?(request)
    cleaned_body = cleaned_request_body(request)
    match = Constraint::OptIn::OPT_IN_RESPONSES.detect do |opt_in|
      cleaned_body.include?(opt_in)
    end
    match.present?
  end
end
