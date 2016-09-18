module Constraint
  class OptIn
    OPT_IN_RESPONSES = %w(START).freeze

    def matches?(request)
      cleaned_body = body(request).gsub(/[^a-z0-9\s]/i, '').strip.upcase
      OPT_IN_RESPONSES.include?(cleaned_body)
    end

    private

    def body(request)
      request.request_parameters['Body']
    end
  end
end
