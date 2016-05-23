require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { create(:question) }

  describe "#perform" do
    let(:organization) { create(:organization, :with_successful_phone) }
    let(:user) { create(:user, organization: organization) }

    it "sends a message to the user" do
      expect{
        subject.perform(user)
      }.to change{FakeMessaging.messages.count}.by(1)
    end

    it "creates an inquiry" do
      expect {
        subject.perform(user)
      }.to change{subject.inquiries.count}.by(1)
    end

    context "with an outstanding inquiry" do
      before(:each) do
        subject.perform(user)
      end

      it "does not create an inquiry" do
        expect {
          subject.perform(user)
        }.not_to change{subject.inquiries.count}
      end
    end
  end
end
