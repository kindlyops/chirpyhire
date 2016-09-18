module Constraint
  class OptOut
    OPT_OUT_RESPONSES = %w(STOP STOPALL UNSUBSCRIBE CANCEL END QUIT).freeze

    def matches?(request)
      OPT_OUT_RESPONSES.include?(body(request).gsub(/[^a-z0-9\s]/i, '').strip.upcase)
    end

    private

    def body(request)
      request.request_parameters['Body']
    end
  end
end
