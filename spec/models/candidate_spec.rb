require 'rails_helper'

RSpec.describe Candidate, type: :model do
  let(:organization) { create(:organization, :with_account, :with_question) }
  let(:account) { organization.accounts.first }
  let(:search) { create(:search, account: account) }

  let(:candidate) { create(:candidate, organization: organization) }
  let(:user) { candidate.user }

  describe "#last_referrer" do
    context "with referrers" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the referrer created last" do
        expect(candidate.last_referrer).to eq(last_referral.referrer)
      end
    end

    context "without referrers" do
      it "is a NullReferrer" do
        expect(candidate.last_referrer).to be_a(NullReferrer)
      end
    end
  end

  describe "#last_referral" do
    context "with referrals" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the referral created last" do
        expect(candidate.last_referral).to eq(last_referral)
      end
    end

    context "without referrals" do
      it "is a NullReferral" do
        expect(candidate.last_referral).to be_a(NullReferral)
      end
    end
  end

  describe "#last_referred_at" do
    context "with referrals" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the last referral's created_at" do
        expect(candidate.last_referred_at).to eq(last_referral.created_at)
      end
    end

    context "without referrals" do
      it "is nil" do
        expect(candidate.last_referred_at).to be_nil
      end
    end
  end

  describe "#last_referrer_name" do
    context "with referrers" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the last referrer's name" do
        expect(candidate.last_referrer_name).to eq(last_referral.referrer.name)
      end
    end

    context "without referrers" do
      it "is nil" do
        expect(candidate.last_referrer_name).to be_blank
      end
    end
  end

  describe "#last_referrer_phone_number" do
    context "with referrers" do
      let!(:old_referral) { create(:referral, candidate: candidate, created_at: 2.days.ago) }
      let!(:last_referral) { create(:referral, candidate: candidate) }

      it "returns the last referrer's phone number" do
        expect(candidate.last_referrer_phone_number).to eq(last_referral.referrer.phone_number)
      end
    end

    context "without referrers" do
      it "is nil" do
        expect(candidate.last_referrer_phone_number).to be_blank
      end
    end
  end

  describe "#subscribe" do
    it "creates a subscription" do
      expect {
        candidate.subscribe
      }.to change{user.subscriptions.with_deleted.count}.by(1)
    end
  end

  describe "#subscribed?" do
    context "when subscribed to the organization" do
      it "is true" do
        candidate.subscribe
        expect(candidate.subscribed?).to eq(true)
      end
    end

    context "when not subscribed to the organization" do
      it "is false" do
        expect(candidate.subscribed?).to eq(false)
      end
    end
  end

  describe "#unsubscribe" do
    context "with a subscription" do
      let(:subscription) { candidate.subscribe }

      it "soft deletes a subscription" do
        expect {
          candidate.unsubscribe
        }.to change{subscription.reload.deleted?}.from(false).to(true)
      end
    end
  end

  describe "#unsubscribed?" do
    context "when subscribed to the organization" do
      it "is false" do
        candidate.subscribe
        expect(candidate.unsubscribed?).to eq(false)
      end
    end

    context "when not subscribed to the organization" do
      it "is true" do
        expect(candidate.unsubscribed?).to eq(true)
      end
    end
  end

  describe "#has_other_search_in_progress?" do
    context "without any searches in progress" do
      it "is false" do
        expect(candidate.has_other_search_in_progress?(nil)).to eq(false)
      end
    end

    context "without another search in progress" do
      before(:each) do
        search.candidates << candidate
        search.search_candidates.each(&:processing!)
      end

      it "is false" do
        expect(candidate.has_other_search_in_progress?(search)).to eq(false)
      end
    end

    context "with another search in progress" do
      let(:another_search) { create(:search, account: account) }

      before(:each) do
        another_search.candidates << candidate
        another_search.search_candidates.each(&:processing!)
      end

      it "is true" do
        expect(candidate.has_other_search_in_progress?(search)).to eq(true)
      end
    end
  end

  describe "#oldest_pending_search_candidate" do
    context "without search candidates" do
      it "is nil" do
        expect(candidate.oldest_pending_search_candidate).to be_nil
      end
    end

    context "with search candidates" do
      before(:each) do
        search.candidates << candidate
      end

      context "that are not pending" do
        before(:each) do
          search.search_candidates.each(&:processing!)
        end

        it "is nil" do
          expect(candidate.oldest_pending_search_candidate).to be_nil
        end
      end

      context "that are pending" do
        let(:another_search) { create(:search, account: account) }

        before(:each) do
          another_search.candidates << candidate
          search.search_candidates.update_all(created_at: 2.days.ago)
        end

        it "returns the one with the oldest created_at timestamp" do
          expect(candidate.oldest_pending_search_candidate).to eq(search.search_candidates.first)
        end
      end
    end
  end

  describe "#recently_answered_negatively?" do
    let(:question) { organization.questions.first }

    context "without recent answers to the question" do
      it "is false" do
        expect(candidate.recently_answered_negatively?(question)).to eq(false)
      end
    end

    context "with recent answers to the question" do
      let(:recent_answer) { create(:answer, candidate: candidate, question: question) }

      context "that are positive" do
        before(:each) do
          recent_answer.update(body: "Y")
        end

        it "is false" do
          expect(candidate.recently_answered_negatively?(question)).to eq(false)
        end
      end

      context "that are negative" do
        before(:each) do
          recent_answer.update(body: "N")
        end

        it "is true" do
          expect(candidate.recently_answered_negatively?(question)).to eq(true)
        end
      end
    end
  end

  describe "#recently_answered_positively?" do
    let(:question) { organization.questions.first }

    context "without recent answers to the question" do
      it "is false" do
        expect(candidate.recently_answered_positively?(question)).to eq(false)
      end
    end

    context "with recent answers to the question" do
      let(:recent_answer) { create(:answer, candidate: candidate, question: question) }

      context "that are positive" do
        before(:each) do
          recent_answer.update(body: "Y")
        end

        it "is true" do
          expect(candidate.recently_answered_positively?(question)).to eq(true)
        end
      end

      context "that are negative" do
        before(:each) do
          recent_answer.update(body: "N")
        end

        it "is true" do
          expect(candidate.recently_answered_positively?(question)).to eq(false)
        end
      end
    end
  end

  describe "#most_recent_inquiry" do
    context "without inquiries" do
      it "is nil" do
        expect(candidate.most_recent_inquiry).to be_nil
      end
    end

    context "with inquiries" do
      let!(:most_recent_inquiry) { create(:inquiry, candidate: candidate) }
      let!(:older_inquiry) { create(:inquiry, candidate: candidate, created_at: 2.days.ago) }

      it "returns the inquiry with the most recent created_at" do
        expect(candidate.most_recent_inquiry).to eq(most_recent_inquiry)
      end
    end
  end

  describe "#processing_search_candidate" do
    context "without processing search candidates" do
      it "is nil" do
        expect(candidate.processing_search_candidate).to be_nil
      end
    end

    context "with a processing search candidate" do
      let!(:processing_search_candidate) { create(:search_candidate, candidate: candidate, status: SearchCandidate.statuses[:processing]) }

      it "is the search candidate" do
        expect(candidate.processing_search_candidate).to eq(processing_search_candidate)
      end
    end
  end

  describe "#has_pending_searches?" do
    context "with pending search candidates" do
      before(:each) do
        search.candidates << candidate
      end

      it "is true" do
        expect(candidate.has_pending_searches?).to eq(true)
      end
    end

    context "without pending search candidates" do
      before(:each) do
        search.search_candidates.each(&:processing!)
      end

      it "is false" do
        expect(candidate.has_pending_searches?).to eq(false)
      end
    end
  end
end
