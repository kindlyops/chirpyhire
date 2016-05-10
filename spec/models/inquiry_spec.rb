require 'rails_helper'

RSpec.describe Inquiry, type: :model do

  describe "#expects?" do
    context "question expects media" do
      let(:inquiry) { create(:inquiry, :with_media_question) }

      context "message has media" do
        let(:message) { create(:message, properties: { "MediaUrl0" => "path/to/image" }) }

        it "is true" do
          expect(inquiry.expects?(message)).to eq(true)
        end
      end

      context "message does not have media" do
        let(:message) { create(:message, properties: { "Body" => Faker::Lorem.word }) }

        it "is false" do
          expect(inquiry.expects?(message)).to eq(false)
        end
      end
    end

    context "question expects text" do
      let(:inquiry) { create(:inquiry, :with_text_question) }

      context "message has text" do
        let(:message) { create(:message, properties: { "Body" => Faker::Lorem.word }) }

        it "is true" do
          expect(inquiry.expects?(message)).to eq(true)
        end
      end

      context "message does not have text" do
        let(:message) { create(:message, properties: { "MediaUrl0" => "path/to/image" }) }

        it "is false" do
          expect(inquiry.expects?(message)).to eq(false)
        end
      end
    end
  end
end
