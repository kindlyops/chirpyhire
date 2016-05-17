require 'rails_helper'

RSpec.describe Inquiry, type: :model do

  let(:messaging) { FakeMessaging.new("foo", "bar") }
  let(:from) { Faker::PhoneNumber.cell_phone }
  let(:to) { Faker::PhoneNumber.cell_phone }
  let(:body) { Faker::Lorem.word }
  let(:message) { messaging.create(from: from, to: to, body: body) }

  describe "#expects?" do
    context "question expects media" do
      let(:inquiry) { create(:inquiry, :with_image_question) }

      context "message has media" do
        let(:message) { messaging.create(from: from, to: to, body: body, format: :image) }

        let(:answer) { build(:answer, message_sid: message.sid) }

        it "is true" do
          expect(inquiry.expects?(answer)).to eq(true)
        end
      end

      context "message does not have media" do
        let(:answer) { build(:answer, message_sid: message.sid) }

        it "is false" do
          expect(inquiry.expects?(answer)).to eq(false)
        end
      end
    end

    context "question expects text" do
      let(:inquiry) { create(:inquiry, :with_text_question) }

      context "message has text" do
        let(:answer) { build(:answer, message_sid: message.sid) }

        it "is true" do
          expect(inquiry.expects?(answer)).to eq(true)
        end
      end

      context "message does not have text" do
        let(:message) { messaging.create(from: from, to: to, body: "", format: :image) }
        let(:answer) { build(:answer, message_sid: message.sid) }

        it "is false" do
          expect(inquiry.expects?(answer)).to eq(false)
        end
      end
    end
  end
end
