module Logging::Logger
  def log(log_message, extra_info)
    Rollbar.debug(
      log_message,
      extra_info
    )
  end
end
