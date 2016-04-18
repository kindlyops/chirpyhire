require 'rails_helper'

RSpec.describe ReferralsController, vcr: { cassette_name: "ReferralsController" }, type: :controller do

  let(:organization) { create(:organization_with_phone) }
  let(:sender_phone_number) { "+15555555555" }
  let(:media_url) { "/2010-04-01/Accounts/AC207d54ae9c08379e9e356faa6fb96f41/Messages/MMfaeed26d122c527a06e14768198c6a06/Media/MEdfa8631eb3ab5a0bf472d0e3fb5b7a76" }
  let(:url) { "https://api.twilio.com/#{media_url}" }

  let(:params) do
    {
      "To" => organization.phone_number,
      "From" => sender_phone_number,
      "MessageSid" => "123",
      "MediaUrl0" => url
    }
  end

  describe "#create" do
    it "creates a message" do
      expect {
        post :create, params
      }.to change{organization.messages.count}.by(1)
    end

    context "with a recognized sender" do
      let!(:sender) { create(:user, phone_number: sender_phone_number) }

      context "that is a referrer for the organization" do
        before(:each) do
          create(:referrer, organization: organization, user: sender)
        end

        it "creates a referral" do
          expect {
            post :create, params
          }.to change{organization.referrals.count}.by(1)
        end

        context "without an existing lead" do
          it "creates a lead" do
            expect {
              post :create, params
            }.to change{organization.leads.count}.by(1)
          end

          context "without a user with the lead's phone number" do
            it "creates a user" do
              expect {
                post :create, params
              }.to change{User.count}.by(1)
            end
          end

          context "with a user with the lead's phone number" do
            before(:each) do
              create(:user, phone_number: "+14047908943")
            end

            it "does not create a new user" do
              expect {
                post :create, params
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
              post :create, params
            }.not_to change{Lead.count}
          end
        end
      end

      context "that is not a referrer for the organization" do
        it "does not create a referral" do
          expect {
            post :create, params
          }.not_to change{Referral.count}
        end

        it "does not create a lead" do
          expect {
            post :create, params
          }.not_to change{Lead.count}
        end

        context "without a user with the lead's phone number" do
          it "does not create a user" do
            expect {
              post :create, params
            }.not_to change{User.count}
          end
        end
      end
    end

    context "with an unrecognized sender" do
      it "creates a user" do
        expect {
          post :create, params
        }.to change{User.count}.by(1)
      end

      it "does not create a referral" do
        expect {
          post :create, params
        }.not_to change{Referral.count}
      end

      it "does not create a lead" do
        expect {
          post :create, params
        }.not_to change{Lead.count}
      end
    end
  end
end
