class Constraint::Brokers::OptOut < Constraint::Base
  OPT_OUT_RESPONSES = %w(STOP STOPALL UNSUBSCRIBE CANCEL END QUIT).freeze

  def matches?(request)
    @request = request

    broker.present? && OPT_OUT_RESPONSES.include?(cleaned_request_body)
  end

  def broker
    Broker.find_by(phone_number: to)
  end

  def to
    request.request_parameters['To']
  end
end
