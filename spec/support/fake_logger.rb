class FakeLogger
  @@logged_messages = []

  cattr_accessor :logged_messages

  def self.log(message)
    logged_messages.push(message)
  end
end

module Logging
  Logger = FakeLogger
end
RSpec.configure { |config| config.before(:each) { FakeLogger.logged_messages = [] } }
