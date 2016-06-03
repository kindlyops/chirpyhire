require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "#has_address?" do
    context "without a body" do
      let(:message) { create(:message, body: nil) }

      it "is false" do
        expect(message.has_address?).to eq(false)
      end
    end

    context "with a body" do
      let(:message) { create(:message, body: "Test Body") }

      before(:each) do
        allow(message).to receive(:address).and_return(OpenStruct.new(found?: true))

        expect(message.has_address?).to eq(true)
      end
    end
  end
end
