require 'rails_helper'

RSpec.describe SearchCandidate, type: :model do
  let(:search_candidate) { create(:search_candidate) }
  let(:candidate) { search_candidate.candidate }
  let(:search) { search_candidate.search }
  let(:search_question) { create(:search_question, search: search) }
  let(:question) { search_question.question }

  describe "#determine_fit" do
    context "with recent answers to search questions" do
      before(:each) do
        create(:answer, candidate: candidate, question: question)
      end

      context "that are negative" do
        before(:each) do
          Answer.update_all(body: "N")
        end

        it "is a bad fit" do
          expect {
            search_candidate.determine_fit
          }.to change{search_candidate.fit}.from("possible_fit").to("bad_fit")
        end
      end

      context "that are positive" do
        context "that are all answered" do
          before(:each) do
            second_search_question = create(:search_question, search: search)
            create(:answer, candidate: candidate, question: second_search_question.question)
            Answer.update_all(body: "Y")
          end

          it "is a good fit" do
            expect {
              search_candidate.determine_fit
            }.to change{search_candidate.fit}.from("possible_fit").to("good_fit")
          end
        end

        context "that are not all answered" do
          before(:each) do
            second_search_question = create(:search_question, search: search)
            Answer.update_all(body: "Y")
          end

          it "is a possible fit" do
            search_candidate.determine_fit
            expect(search_candidate.possible_fit?).to eq(true)
          end
        end
      end
    end
  end
end
