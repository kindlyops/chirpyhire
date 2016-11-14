class Constraint::OptIn
  include Constraint::ConstraintHelper
  OPT_IN_RESPONSES = %w(START).freeze

  def matches?(request)
    @request = request
    return false if candidate_present?

    cleaned_body = cleaned_request_body
    match = OPT_IN_RESPONSES.detect do |opt_in|
      cleaned_body.include?(opt_in)
    end
    match.present?
  end
end
