class Constraint::Broker::OptIn < Constraint::Base
  OPT_IN_RESPONSES = %w(START).freeze

  def matches?(request)
    @request = request

    match = OPT_IN_RESPONSES.detect do |opt_in|
      cleaned_request_body.include?(opt_in)
    end
    broker.present? && match.present?
  end

  def broker
    Broker.find_by(phone_number: to)
  end

  def to
    request.request_parameters['To']
  end
end
