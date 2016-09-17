# frozen_string_literal: true
module Constraint
  class OptOut
    OPT_OUT_RESPONSES = %w(STOP STOPALL UNSUBSCRIBE CANCEL END QUIT).freeze

    def matches?(request)
      cleaned_body = body(request).gsub(/[^a-z0-9\s]/i, '').strip.upcase
      OPT_OUT_RESPONSES.include?(cleaned_body)
    end

    private

    def body(request)
      request.request_parameters['Body']
    end
  end
end
