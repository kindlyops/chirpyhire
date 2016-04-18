class OptOutConstraint
  OPT_OUT_RESPONSES = %w(STOP STOPALL UNSUBSCRIBE CANCEL END QUIT)

  def matches?(request)
    OPT_OUT_RESPONSES.include?(body(request).strip.upcase)
  end

  private

  def body(request)
    request.request_parameters["Body"]
  end
end
