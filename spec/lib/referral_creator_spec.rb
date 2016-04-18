require 'rails_helper'

RSpec.describe ReferralCreator, vcr: { cassette_name: "ReferralCreator" } do

  let!(:sender) { create(:user) }
  let(:organization) { create(:organization_with_phone) }
  let(:media_url) { "/2010-04-01/Accounts/AC207d54ae9c08379e9e356faa6fb96f41/Messages/MMfaeed26d122c527a06e14768198c6a06/Media/MEdfa8631eb3ab5a0bf472d0e3fb5b7a76" }
  let(:url) { "https://api.twilio.com/#{media_url}"}
  let(:message) { create(:message, organization: organization, media_url: url) }

  subject do
    ReferralCreator.new(sender: sender, message: message, organization: organization)
  end

  context "sender is a referrer for the organization" do
    before(:each) do
      create(:referrer, organization: organization, user: sender)
    end

    it "creates a referral" do
      expect {
        subject.call
      }.to change{organization.referrals.count}.by(1)
    end

    context "without an existing lead" do
      it "creates a lead" do
        expect {
          subject.call
        }.to change{organization.leads.count}.by(1)
      end

      context "without a user with the lead's phone number" do
        it "creates a user" do
          expect {
            subject.call
          }.to change{User.count}.by(1)
        end
      end

      context "with a user with the lead's phone number" do
        before(:each) do
          create(:user, phone_number: "+14047908943")
        end

        it "does not create a new user" do
          expect {
            subject.call
          }.not_to change{User.count}
        end
      end
    end

    context "with an existing lead" do
      before(:each) do
        user = create(:user, phone_number: "+14047908943")
        create(:lead, organization: organization, user: user)
      end

      it "does not create a new lead" do
        expect {
          subject.call
        }.not_to change{Lead.count}
      end
    end
  end

  context "that is not a referrer for the organization" do
    it "does not create a referral" do
      expect {
        subject.call
      }.not_to change{Referral.count}
    end

    it "does not create a lead" do
      expect {
        subject.call
      }.not_to change{Lead.count}
    end

    context "without a user with the lead's phone number" do
      it "does not create a user" do
        expect {
          subject.call
        }.not_to change{User.count}
      end
    end
  end
end
