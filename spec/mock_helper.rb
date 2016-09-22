require 'rspec/mocks/standalone'

class Mock
  extend ::RSpec::Mocks::ExampleMethods
  def self.message_handler(sender, message)
    mock_message_handler = double('mock_message_handler')
    allow(mock_message_handler).to receive(:call).and_return(message)
    allow(MessageHandler).to receive(:new).with(sender, message.sid).and_return(mock_message_handler)
  end
end
