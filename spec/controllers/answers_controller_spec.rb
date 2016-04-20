require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:organization) { create(:organization_with_phone) }
  let(:sender_phone_number) { "+15555555555" }
  let(:params) do
    {
      "To" => organization.phone_number,
      "From" => sender_phone_number,
      "MessageSid" => "123",
      "Body" => "Y"
    }
  end

  describe "#create" do
    context "without an existing lead" do
      it "returns an error" do
        post :create, params
        expect(response.body).to include("Sorry I didn't understand that.")
      end

      it "does not create an answer" do
        expect {
          post :create, params
        }.not_to change{Answer.count}
      end

      it "creates a message" do
        expect {
          post :create, params
        }.to change{organization.messages.count}.by(1)
      end
    end

    context "with an existing lead" do
      let(:user) { create(:user, phone_number: sender_phone_number) }
      let(:lead) { create(:lead, organization: organization, user: user) }

      context "without an inquiry" do
        it "returns an error" do
          post :create, params
          expect(response.body).to include("Sorry I didn't understand that.")
        end

        it "does not create an answer" do
          expect {
            post :create, params
          }.not_to change{Answer.count}
        end

        it "creates a message" do
          expect {
            post :create, params
          }.to change{organization.messages.count}.by(1)
        end
      end

      context "with an inquiry" do
        let(:inquiry) { create(:inquiry, lead: lead) }

        it "creates an answer" do
          expect {
            expect {
              post :create, params
            }.to change{lead.answers.count}.by(1)
          }.to change{inquiry.question.answers.count}.by(1)
        end

        it "is OK" do
          post :create, params
          expect(response).to be_ok
        end

        it "creates a message" do
          expect {
            post :create, params
          }.to change{organization.messages.count}.by(1)
        end
      end
    end
  end
end
