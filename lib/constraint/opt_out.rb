class Constraint::OptOut
  include Constraint::ConstraintHelper
  OPT_OUT_RESPONSES = %w(STOP STOPALL UNSUBSCRIBE CANCEL END QUIT).freeze

  def matches?(request)
    @request = request
    
    OPT_OUT_RESPONSES.include?(cleaned_request_body)
  end
end
