class OptInConstraint
  def matches?(request)
    body(request).strip.upcase == "CARE"
  end

  private

  def body(request)
    request.request_parameters["Body"]
  end
end
