require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe "#validation" do
    let(:messaging) { FakeMessaging.new("foo", "bar") }
    let(:from) { Faker::PhoneNumber.cell_phone }
    let(:to) { Faker::PhoneNumber.cell_phone }
    let(:message) { messaging.create(from: from, to: to, body: "", format: :text) }

    let(:organization) { create(:organization, phone_number: to) }
    let(:survey) { create(:survey, organization: organization) }
    let(:question) { create(:question, survey: survey) }
    let(:inquiry) { create(:inquiry, question: question) }
    let(:answer) { build(:answer, inquiry: inquiry, message: create(:message, sid: message.sid)) }

    context "inquiry does not expect the answer's message format" do
      it "adds an inquiry error to the answer" do
        answer.valid?
        expect(answer.errors).to include(:inquiry)
      end
    end
  end
end
