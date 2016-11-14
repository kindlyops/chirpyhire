class Constraint::OptOut
  include Constraint::ConstraintHelper
  OPT_OUT_RESPONSES = %w(STOP STOPALL UNSUBSCRIBE CANCEL END QUIT).freeze

  def matches?(request)
    cleaned_body = cleaned_request_body(request)
    OPT_OUT_RESPONSES.include?(cleaned_body)
  end
end
