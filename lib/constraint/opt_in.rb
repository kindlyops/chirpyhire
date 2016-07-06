module Constraint
  class OptIn
    OPT_IN_RESPONSES = %w(START YES)

    def matches?(request)
      OPT_IN_RESPONSES.include?(body(request).gsub(/[^a-z0-9\s]/i, '').strip.upcase)
    end

    private

    def body(request)
      request.request_parameters["Body"]
    end
  end
end
