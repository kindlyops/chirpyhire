class Constraint::Base
  attr_reader :request

  def cleaned_request_body
    clean(body)
  end

  def body
    request.request_parameters['Body']
  end

  def clean(string)
    remove_non_alphanumerics(string).strip.upcase
  end

  def remove_non_alphanumerics(string)
    string.gsub(/[^a-z0-9\s]/i, '')
  end
end
