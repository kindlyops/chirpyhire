class Constraint::Broker < Constraint::Base
  def matches?(request)
    @request = request

    broker.present?
  end

  def broker
    Broker.find_by(phone_number: to)
  end

  def to
    request.request_parameters['To']
  end
end
