module Logging
  class Logger
    def self.log(log_message, extra_info = nil)
      if Rails.env.development?
        puts log_message, extra_info
      else 
        Rollbar.debug(
          log_message,
          extra_info
        )
      end
    end
  end
end
