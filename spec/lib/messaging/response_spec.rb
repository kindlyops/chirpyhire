require 'rails_helper'

RSpec.describe Messaging::Response do
  describe ".error" do
    it "is an sms response" do
      expect(Messaging::Response.error).to be_an_instance_of(Messaging::Response)
    end

    it "includes a friendly error message" do
      expect(Messaging::Response.error.text).to include("Sorry I didn't understand that.")
    end
  end

  describe "#text" do
    let(:response) do
      Messaging::Response.new do |r|
        r.Message "test message"
      end
    end

    it "includes the message text" do
      expect(response.text).to include("test message")
    end
  end
end
