require 'rails_helper'

RSpec.describe Inquiry, type: :model do

  let(:messaging) { FakeMessaging.new("foo", "bar") }
  let(:from) { Faker::PhoneNumber.cell_phone }
  let(:to) { Faker::PhoneNumber.cell_phone }
  let(:body) { Faker::Lorem.word }
  let(:message) { messaging.create(from: from, to: to, body: body) }

  describe "#expects?" do
    context "feature expects document" do
      let(:inquiry) { create(:inquiry) }

      context "message has media" do
        let(:message) { messaging.create(from: from, to: to, body: body, format: :image) }

        let(:answer) { build(:answer, message: create(:message, sid: message.sid)) }

        it "is true" do
          expect(inquiry.expects?(answer)).to eq(true)
        end
      end

      context "message does not have media" do
        let(:message) { messaging.create(from: from, to: to, body: body, format: :text) }

        let(:answer) { build(:answer, message: create(:message, sid: message.sid)) }

        it "is false" do
          expect(inquiry.expects?(answer)).to eq(false)
        end
      end
    end
  end
end
