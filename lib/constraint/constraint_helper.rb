module Constraint::ConstraintHelper
  def cleaned_request_body(request)
    clean(body(request))
  end

  private

  def body(request)
    request.request_parameters['Body']
  end

  def clean(string)
    remove_non_alphanumerics(string).strip.upcase
  end

  def remove_non_alphanumerics(string)
    string.gsub(/[^a-z0-9\s]/i, '')
  end
end
