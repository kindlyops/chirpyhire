require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, :with_owner) }
  let(:owner) { organization.accounts.first }

  describe "#ask", vcr: { cassette_name: "Organization_ask" } do
    let!(:organization) { create(:organization, :with_successful_phone, :with_question) }
    let(:candidate) { create(:candidate, organization: organization) }
    let(:question) { organization.questions.first }
    let(:inquiry) { candidate.inquiries.build(question: question) }
    it "creates a message" do
      expect {
        organization.ask(inquiry)
      }.to change{organization.messages.count}.by(1)
    end
  end

  describe "#owner" do
    it "returns an account with the owner role" do
      expect(organization.owner).to eq(owner)
    end
  end

  describe "#owner_first_name" do
    it "returns the owner's first name" do
      expect(organization.owner_first_name).to eq(owner.first_name)
    end
  end

  describe "#subscribed_candidates" do
    context "without candidates" do
      it "is empty" do
        expect(organization.subscribed_candidates).to be_empty
      end
    end

    context "with candidates" do
      let!(:subscribed_candidates) { create_list(:candidate, 2, :with_subscription, organization: organization) }
      let!(:unsubscribed_candidate) { create(:candidate, organization: organization) }

      context "with some unsubscribed" do
        it "is only the subscribed candidates" do
          expect(organization.subscribed_candidates).to eq(subscribed_candidates)
        end

        context "with some of the subscribed candidates not having a phone number" do
          let(:subscribed_candidate_without_phone_number) do
            candidate = subscribed_candidates.sample
            candidate.user.update(phone_number: nil)
            candidate
          end

          it "is only the subscribed candidates with a phone number" do
            expect(organization.subscribed_candidates).not_to include(subscribed_candidate_without_phone_number)
          end
        end
      end
    end
  end
end
