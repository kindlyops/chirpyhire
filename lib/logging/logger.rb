module Logging
  class Logger
    def self.log(log_message, extra_info = nil)
      if Rails.env.development?
        Rails.logger.debug log_message
        Rails.logger.debug extra_info
      else
        Rollbar.debug(
          log_message,
          extra_info
        )
      end
    end
  end
end
