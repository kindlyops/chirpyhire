require 'rails_helper'

RSpec.describe Inquisitor, vcr: { cassette_name: "Inquisitor" } do
  let(:organization) { create(:organization_with_successful_phone) }
  let(:question) { create(:question) }
  let(:lead) { create(:lead, organization: organization) }

  subject { Inquisitor.new(lead: lead, question: question) }

  describe "#call" do
    context "with an unanswered recent inquiry" do
      let!(:inquiry) { create(:inquiry, lead: lead) }

      before(:each) do
        lead.answers.destroy_all
      end

      it "does not inquire the question" do
        expect {
          subject.call
        }.not_to change{question.inquiries.count}
      end

      it "sets up inquiring the question in the near future"
    end

    context "with a recent answer to the question" do
      let!(:answer) { create(:answer, lead: lead, question: question) }

      it "does not inquire the question" do
        expect {
          subject.call
        }.not_to change{question.inquiries.count}
      end

      context "with other searches" do
        let(:searches) { create_list(:search, 2, organization: organization) }
        before(:each) do
          searches.each do |search|
            search << lead
          end

          5.times do
            create(:search_question, search: searches.sample)
          end
        end

        context "with a 'next question' to the question" do
          let(:next_question) { Question.all.sample }

          before(:each) do
            create(:search_question, search: searches.sample, question: question, next_question: next_question)
          end

          it "inquires the next question" do
            expect {
              subject.call
            }.to change{next_question.inquiries.count}.by(1)
          end
        end

        context "without a 'next question' to the question" do
          context "with unasked questions in other searches" do
            let(:oldest_unasked_question) do
              lead.questions_unasked_recently.order(:created_at).first
            end

            it "inquires the oldest unasked question" do
              expect {
                subject.call
              }.to change{oldest_unasked_question.inquiries.count}.by(1)
            end
          end
        end
      end
    end

    context "without an unanswered recent inquiry" do
      context "without a recent answer to the question" do
        it "inquires the question" do
          expect {
            subject.call
          }.to change{question.inquiries.count}.by(1)
        end
      end
    end
  end
end
