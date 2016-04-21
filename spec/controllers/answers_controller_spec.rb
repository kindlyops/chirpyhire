require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:organization) { create(:organization, :with_phone, :with_account) }
  let(:account) { organization.accounts.first }
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
    context "without an ongoing search for the lead" do
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

    context "with an ongoing search for the lead" do
      let(:search) { create(:search, account: account) }
      let(:questions) { create_list(:question, 2, organization: organization)}
      let(:user) { create(:user, phone_number: sender_phone_number) }
      let(:lead) { create(:lead, organization: organization, user: user) }

      let!(:first_search_question) do
        search_question = create(:search_question, question: questions.first, next_question: questions.last)
        search.search_questions << search_question
        search_question
      end

      let!(:second_search_question) do
        search_question = create(:search_question, question: questions.last)
        search.search_questions << search_question
        search_question
      end

      let!(:search_lead) do
        search.leads << lead
        lead.search_leads.each(&:processing!)
        lead.search_leads.find_by(search: search)
      end

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
        let!(:inquiry) { create(:inquiry, lead: lead, question: questions.first) }

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

        it "continues the search" do
          expect(InquisitorJob).to receive(:perform_later).with(search_lead, second_search_question)
          post :create, params
        end
      end
    end
  end
end
