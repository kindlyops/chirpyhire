require 'rails_helper'

RSpec.describe Notice, type: :model do
  subject { create(:notice) }

  describe "#children" do
    context "with notifications" do
      subject { create(:notice, :with_notification) }
      let(:notifications) { subject.notifications }

      it "is the notifications" do
        expect(subject.children).to eq(notifications)
      end
    end

    it "is empty" do
      expect(subject.children).to be_empty
    end
  end

  describe "#perform" do
    let(:organization) { create(:organization, :with_successful_phone) }
    let(:user) { create(:user, organization: organization) }

    it "sends a message to the user" do
      expect{
        subject.perform(user)
      }.to change{FakeMessaging.messages.count}.by(1)
    end
  end
end
