require 'rails_helper'

RSpec.describe Lead, type: :model do
  let(:organization) { create(:organization, :with_account) }
  let(:account) { organization.accounts.first }
  let(:search) { create(:search, account: account) }

  let(:lead) { create(:lead, organization: organization) }

  describe "#has_other_search_in_progress?" do
    context "without any searches in progress" do
      it "is false" do
        expect(lead.has_other_search_in_progress?(nil)).to eq(false)
      end
    end

    context "without another search in progress" do
      before(:each) do
        search.leads << lead
        search.search_leads.each(&:processing!)
      end

      it "is false" do
        expect(lead.has_other_search_in_progress?(search)).to eq(false)
      end
    end

    context "with another search in progress" do
      let(:another_search) { create(:search, account: account) }

      before(:each) do
        another_search.leads << lead
        another_search.search_leads.each(&:processing!)
      end

      it "is true" do
        expect(lead.has_other_search_in_progress?(search)).to eq(true)
      end
    end
  end

  describe "#oldest_pending_search_lead" do
    context "without search leads" do
      it "is nil" do
        expect(lead.oldest_pending_search_lead).to be_nil
      end
    end

    context "with search leads" do
      before(:each) do
        search.leads << lead
      end

      context "that are not pending" do
        before(:each) do
          search.search_leads.each(&:processing!)
        end

        it "is nil" do
          expect(lead.oldest_pending_search_lead).to be_nil
        end
      end

      context "that are pending" do
        let(:another_search) { create(:search, account: account) }

        before(:each) do
          another_search.leads << lead
          search.search_leads.update_all(created_at: 2.days.ago)
        end

        it "returns the one with the oldest created_at timestamp" do
          expect(lead.oldest_pending_search_lead).to eq(search.search_leads.first)
        end
      end
    end
  end

  describe "#recently_answered_negatively?" do
    let(:question) { create(:question, organization: organization) }

    context "without recent answers to the question" do
      it "is false" do
        expect(lead.recently_answered_negatively?(question)).to eq(false)
      end
    end

    context "with recent answers to the question" do
      let(:recent_answer) { create(:answer, lead: lead, question: question) }

      context "that are positive" do
        before(:each) do
          recent_answer.update(body: "Y")
        end

        it "is false" do
          expect(lead.recently_answered_negatively?(question)).to eq(false)
        end
      end

      context "that are negative" do
        before(:each) do
          recent_answer.update(body: "N")
        end

        it "is true" do
          expect(lead.recently_answered_negatively?(question)).to eq(true)
        end
      end
    end
  end

  describe "#recently_answered_positively?" do
    let(:question) { create(:question, organization: organization) }

    context "without recent answers to the question" do
      it "is false" do
        expect(lead.recently_answered_positively?(question)).to eq(false)
      end
    end

    context "with recent answers to the question" do
      let(:recent_answer) { create(:answer, lead: lead, question: question) }

      context "that are positive" do
        before(:each) do
          recent_answer.update(body: "Y")
        end

        it "is true" do
          expect(lead.recently_answered_positively?(question)).to eq(true)
        end
      end

      context "that are negative" do
        before(:each) do
          recent_answer.update(body: "N")
        end

        it "is true" do
          expect(lead.recently_answered_positively?(question)).to eq(false)
        end
      end
    end
  end

  describe "#most_recent_inquiry" do
    context "without inquiries" do
      it "is nil" do
        expect(lead.most_recent_inquiry).to be_nil
      end
    end

    context "with inquiries" do
      let!(:most_recent_inquiry) { create(:inquiry, lead: lead) }
      let!(:older_inquiry) { create(:inquiry, lead: lead, created_at: 2.days.ago) }

      it "returns the inquiry with the most recent created_at" do
        expect(lead.most_recent_inquiry).to eq(most_recent_inquiry)
      end
    end
  end

  describe "#processing_search_lead" do
    context "without processing search leads" do
      it "is nil" do
        expect(lead.processing_search_lead).to be_nil
      end
    end

    context "with a processing search lead" do
      let!(:processing_search_lead) { create(:search_lead, lead: lead, status: SearchLead.statuses[:processing]) }

      it "is the search lead" do
        expect(lead.processing_search_lead).to eq(processing_search_lead)
      end
    end
  end

  describe "#has_pending_searches?" do
    context "with pending search leads" do
      before(:each) do
        search.leads << lead
      end

      it "is true" do
        expect(lead.has_pending_searches?).to eq(true)
      end
    end

    context "without pending search leads" do
      before(:each) do
        search.search_leads.each(&:processing!)
      end

      it "is false" do
        expect(lead.has_pending_searches?).to eq(false)
      end
    end
  end
end
