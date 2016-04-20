class Constraint::Answer
  ANSWER_RESPONSES = %w(Y N)

  def matches?(request)
    ANSWER_RESPONSES.include?(body(request).strip.upcase)
  end

  private

  def body(request)
    request.request_parameters["Body"]
  end
end
