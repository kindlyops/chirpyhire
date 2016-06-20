require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "#expected_format" do
    let(:messaging) { FakeMessaging.new("foo", "bar") }
    let(:from) { Faker::PhoneNumber.cell_phone }
    let(:to) { Faker::PhoneNumber.cell_phone }
    let(:message) { messaging.create(from: from, to: to, body: "", format: :text) }

    let(:organization) { create(:organization, phone_number: to) }
    let(:ideal_profile) { organization.ideal_profile }
    let(:ideal_feature) { create(:ideal_feature, ideal_profile: ideal_profile) }
    let(:candidate_feature) { create(:candidate_feature, ideal_feature: ideal_feature) }
    let(:inquiry) { create(:inquiry, candidate_feature: candidate_feature) }
    let(:answer) { build(:answer, inquiry: inquiry, message: create(:message, sid: message.sid)) }
    context "inquiry does not expect the answer's message format" do
      it "adds an inquiry error to the answer" do
        answer.valid?
        expect(answer.errors).to include(:inquiry)
      end
    end
  end
end
