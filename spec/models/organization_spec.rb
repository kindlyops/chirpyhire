require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, :with_account) }

  describe ".for" do
    let(:organization) { create(:organization) }
    it "looks up an organization by phone number" do
      expect(Organization.for(phone: organization.phone_number)).to eq(organization)
    end
  end

  describe "#next_unasked_question_for" do
    let(:user) { create(:user, organization: organization) }

    context "with persona features" do
      let!(:first_question) { create(:persona_feature, priority: 1, candidate_persona: organization.candidate_persona) }
      let!(:second_question) { create(:persona_feature, priority: 2, candidate_persona: organization.candidate_persona) }

      context "with no questions asked" do
        it "is the persona feature with priority 1" do
          expect(organization.next_unasked_question_for(user)).to eq(first_question)
        end
      end

      context "with the first feature asked" do
        before(:each) do
          message = create(:message, user: user)
          create(:inquiry, message: message, persona_feature: first_question)
        end

        it "is the persona feature with priority 2" do
          expect(organization.next_unasked_question_for(user)).to eq(second_question)
        end
      end
    end

    context "without persona features" do
      it "is nil" do
          expect(organization.next_unasked_question_for(user)).to eq(nil)
      end
    end
  end

  describe "#send_message" do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }

    it "sends the sms message" do
      expect{
        organization.send_message(to: user.phone_number, body: "Test")
      }.to change{FakeMessaging.messages.count}.by(1)
    end
  end
end
