class FakeLogger
  def initialize
    @logged_messages = []
  end

  attr_accessor :logged_messages

  def log(message)
    logged_messages.push(message)
  end
end

logger = FakeLogger.new
Logging::Logger = logger
RSpec.configure { |config| config.before(:each) { logger.logged_messages = [] } }
