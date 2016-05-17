require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "#expected_format" do
    let(:messaging) { FakeMessaging.new("foo", "bar") }
    let(:from) { Faker::PhoneNumber.cell_phone }
    let(:to) { Faker::PhoneNumber.cell_phone }
    let(:message) { messaging.create(from: from, to: to, body: "", num_media: "1") }

    let(:answer) { build(:answer, message_sid: message.sid) }
    context "inquiry does not expect the answer's message format" do
      it "adds an inquiry error to the answer" do
        answer.valid?
        expect(answer.errors).to include(:inquiry)
      end
    end
  end
end
