require 'rails_helper'

RSpec.describe Inquisitor, vcr: { cassette_name: "Inquisitor" } do
  let(:organization) { create(:organization_with_successful_phone) }
  let(:question) { create(:question) }
  let(:lead) { create(:lead, organization: organization) }

  describe "#call" do
    context "with a fresh answer from the lead to this question" do
      let!(:answer) { create(:answer, question: question, lead: lead) }

      it "does not create an inquiry" do
        expect {
          Inquisitor.new(lead: lead, question: question).call
        }.not_to change{lead.inquiries.count}
      end

      context "with searches" do
        context "with a next question in a search" do
          it "asks the next question" do
          end
        end
      end
    end

    context "with a fresh inquiry" do
      let(:inquiry) { create(:inquiry, lead: lead)}

      it "does not create an inquiry" do
        expect {
          Inquisitor.new(lead: lead, question: question).call
        }.not_to change{lead.inquiries.count}
      end

      it "asks again in the near future" do
      end
    end

    context "with a stale answer from the lead to this question" do
      let!(:answer) { create(:answer, :stale, question: question, lead: lead) }

      context "with a stale inquiry of the lead" do
        let(:inquiry) { create(:inquiry, :stale, lead: lead) }

        it "creates an inquiry" do
          expect {
            Inquisitor.new(lead: lead, question: question).call
          }.to change{lead.inquiries.count}.by(1)
        end
      end

      context "without any inquiries of the lead" do
        before(:each) do
          lead.inquiries.destroy_all
        end

        it "creates an inquiry" do
          expect {
            Inquisitor.new(lead: lead, question: question).call
          }.to change{lead.inquiries.count}.by(1)
        end
      end
    end

    context "without any answers to this question" do
      before(:each) do
        lead.answers.destroy_all
      end


      context "with a stale inquiry of the lead" do
        let(:inquiry) { create(:inquiry, :stale, lead: lead)}

        it "creates an inquiry" do
          expect {
            Inquisitor.new(lead: lead, question: question).call
          }.to change{lead.inquiries.count}.by(1)
        end
      end

      context "without any inquiries of the lead" do
        before(:each) do
          lead.inquiries.destroy_all
        end

        it "creates an inquiry" do
          expect {
            Inquisitor.new(lead: lead, question: question).call
          }.to change{lead.inquiries.count}.by(1)
        end
      end
    end
  end
end
