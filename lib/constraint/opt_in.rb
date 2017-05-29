class Constraint::OptIn < Constraint::Base
  OPT_IN_RESPONSES = %w[START].freeze

  def matches?(request)
    @request = request

    match = OPT_IN_RESPONSES.detect do |opt_in|
      cleaned_request_body.include?(opt_in)
    end
    match.present?
  end
end
