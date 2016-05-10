require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { create(:question) }

  describe "#children" do
    context "with inquiries" do
      subject { create(:question, :with_inquiry) }
      let(:inquiries) { subject.inquiries }

      it "is the inquiries" do
        expect(subject.children).to eq(inquiries)
      end
    end

    it "is empty" do
      expect(subject.children).to be_empty
    end
  end

  describe "#perform" do
    let(:organization) { create(:organization, :with_successful_phone) }
    let(:user) { create(:user, organization: organization) }

    it "creates a message" do
      expect{
        subject.perform(user)
      }.to change{user.messages.count}.by(1)
    end
  end
end
