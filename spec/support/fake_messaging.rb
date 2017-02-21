Messaging::Client.client = FakeMessaging
RSpec.configure { |config| config.before(:each) { FakeMessaging.messages = [] } }
