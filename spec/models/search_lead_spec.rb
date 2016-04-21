require 'rails_helper'

RSpec.describe SearchLead, type: :model do
  let(:search_lead) { create(:search_lead) }
  let(:lead) { search_lead.lead }
  let(:search) { search_lead.search }
  let(:search_question) { create(:search_question, search: search) }
  let(:question) { search_question.question }

  describe "#determine_fit" do
    context "with recent answers to search questions" do
      before(:each) do
        create(:answer, lead: lead, question: question)
      end

      context "that are negative" do
        before(:each) do
          Answer.update_all(body: "N")
        end

        it "is a bad fit" do
          expect {
            search_lead.determine_fit
          }.to change{search_lead.fit}.from("possible_fit").to("bad_fit")
        end
      end

      context "that are positive" do
        context "that are all answered" do
          before(:each) do
            second_search_question = create(:search_question, search: search)
            create(:answer, lead: lead, question: second_search_question.question)
            Answer.update_all(body: "Y")
          end

          it "is a good fit" do
            expect {
              search_lead.determine_fit
            }.to change{search_lead.fit}.from("possible_fit").to("good_fit")
          end
        end

        context "that are not all answered" do
          before(:each) do
            second_search_question = create(:search_question, search: search)
            Answer.update_all(body: "Y")
          end

          it "is a possible fit" do
            search_lead.determine_fit
            expect(search_lead.possible_fit?).to eq(true)
          end
        end
      end
    end
  end
end
