module Logging
  class Logger
    def self.log(log_message, extra_info = nil)
      Rollbar.debug(
        log_message,
        extra_info
      )
    end
  end
end
