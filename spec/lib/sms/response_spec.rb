require 'rails_helper'

RSpec.describe Sms::Response do
  describe ".error" do
    it "is an sms response" do
      expect(Sms::Response.error).to be_an_instance_of(Sms::Response)
    end

    it "includes a friendly error message" do
      expect(Sms::Response.error.text).to include("Sorry I didn't understand that.")
    end
  end

  describe "#text" do
    let(:response) do
      Sms::Response.new do |r|
        r.Message "test message"
      end
    end

    it "includes the message text" do
      expect(response.text).to include("test message")
    end
  end
end
