require 'rails_helper'

RSpec.describe ReferralsController, vcr: { cassette_name: "ReferralsController" }, type: :controller do

  let(:organization) { create(:organization) }
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
    context "with a recognized sender" do
      let!(:sender) { create(:user, organization: organization, phone_number: sender_phone_number) }

      context "that is a referrer for the organization" do
        let!(:referrer) { create(:referrer, user: sender) }

        it "creates two chirps" do
          expect {
            post :create, params: params
          }.to change{sender.chirps.count}.by(2)
        end

        it "sends the user a template message to send to the referred candidate" do
          post :create, params: params
          expect(FakeMessaging.messages.last.body).to include("I think you would be a great fit here.")
        end

        it "creates a referral" do
          expect {
            post :create, params: params
          }.to change{referrer.referrals.count}.by(1)
        end

        context "without an existing candidate" do
          it "creates a candidate" do
            expect {
              post :create, params: params
            }.to change{organization.candidates.count}.by(1)
          end

          context "without a user with the candidate's phone number" do
            it "creates a user" do
              expect {
                post :create, params: params
              }.to change{organization.users.count}.by(1)
            end
          end

          context "with a user with the candidate's phone number" do
            before(:each) do
              create(:user, organization: organization, phone_number: "+14047908943")
            end

            it "does not create a new user" do
              expect {
                post :create, params: params
              }.not_to change{User.count}
            end
          end
        end

        context "with an existing candidate" do
          before(:each) do
            user = create(:user, phone_number: "+14047908943", organization: organization)
            create(:candidate, user: user)
          end

          it "does not create a new candidate" do
            expect {
              post :create, params: params
            }.not_to change{Candidate.count}
          end
        end
      end

      context "that is not a referrer for the organization" do
        it "creates one chirp" do
          expect {
            post :create, params: params
          }.to change{sender.chirps.count}.by(1)
        end

        it "lets the user know they are not a referrer" do
          post :create, params: params
          expect(FakeMessaging.messages.last.body).to include("if you would like to join the referral program.")
        end

        it "does not create a referral" do
          expect {
            post :create, params: params
          }.not_to change{Referral.count}
        end

        it "does not create a candidate" do
          expect {
            post :create, params: params
          }.not_to change{Candidate.count}
        end

        context "without a user with the candidate's phone number" do
          it "does not create a user" do
            expect {
              post :create, params: params
            }.not_to change{User.count}
          end
        end
      end
    end

    context "with an unrecognized sender" do
      it "lets the user know they are not a referrer" do
        post :create, params: params
        expect(FakeMessaging.messages.last.body).to include("if you would like to join the referral program.")
      end

      it "creates a user for the sender" do
        expect {
          expect {
            post :create, params: params
          }.not_to change{User.where.not(phone_number: params["From"]).count}
        }.to change{User.where(phone_number: params["From"]).count}.by(1)
      end

      it "does not create a referral" do
        expect {
          post :create, params: params
        }.not_to change{Referral.count}
      end

      it "does not create a candidate" do
        expect {
          post :create, params: params
        }.not_to change{Candidate.count}
      end
    end
  end
end
