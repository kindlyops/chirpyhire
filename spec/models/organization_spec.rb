require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, :with_account, :with_survey) }

  describe "#next_unasked_question_for" do
    let(:user) { create(:user, organization: organization) }

    context "with questions" do
      let!(:first_question) { create(:question, type: "AddressQuestion", priority: 1, survey: organization.survey) }
      let!(:second_question) { create(:question, type: "DocumentQuestion", priority: 2, survey: organization.survey) }

      context "with no questions asked" do
        it "is the question with priority 1" do
          expect(organization.next_unasked_question_for(user)).to eq(AddressQuestion.find(first_question.id))
        end
      end

      context "with the first feature asked" do
        before(:each) do
          message = create(:message, user: user)
          create(:inquiry, message: message, question: first_question)
        end

        it "is the question with priority 2" do
          expect(organization.next_unasked_question_for(user)).to eq(DocumentQuestion.find(second_question.id))
        end
      end
    end

    context "without questions" do
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
