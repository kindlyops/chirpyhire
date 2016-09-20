require 'rails_helper'

RSpec.describe Messaging::Message do
  let(:inner_message) { Struct.new(:num_media).new(rand(1..100).to_s) }
  let(:message) { Messaging::Message.new(inner_message) }

  describe '#num_media' do
    it 'converts the message num_media from string to integer' do
      expect(message.num_media).to eq(inner_message.num_media.to_i)
    end
  end
end
