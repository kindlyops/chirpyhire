require 'rails_helper'

RSpec.feature "Surveying Candidates", type: :request do
  let(:organization) { create(:organization) }
  let!(:location) { create(:location, latitude: 38.145, longitude: -122.255, organization: organization)}
  let(:user) { create(:user, organization: organization) }
  let(:account) { create(:account, user: user) }
  let!(:plan) { create(:plan) }

  before(:each) do
    allow(IntercomSyncerJob).to receive(:perform_later).once
  end

  let!(:registrar) { Registrar.new(account).register }
  let(:survey) { organization.survey }
  let(:erica) { create(:candidate, organization: organization) }
  let(:start_message) { FakeMessaging.new("foo", "bar").create(from: erica.phone_number, to: organization.phone_number, body: "START", direction: "inbound", format: :text) }
  let(:start_message_params) do
    {
      "To" => start_message.to,
      "From" => start_message.from,
      "Body" => start_message.body,
      "MessageSid" => start_message.sid
    }
  end

  context "when a candidate has texted START" do
    before(:each) do
      post "/twilio/text", params: start_message_params
    end

    context "and has submitted an address answer to the first address question" do
      let(:address_message) { FakeMessaging.new("foo", "bar").create(from: erica.phone_number, to: organization.phone_number, body: body, direction: "inbound", format: :text) }
      let(:address_message_params) do
        {
          "To" => address_message.to,
          "From" => address_message.from,
          "Body" => address_message.body,
          "MessageSid" => address_message.sid
        }
      end

      before(:each) do
        post "/twilio/text", params: address_message_params
      end

      context "that is a valid address", vcr: { cassette_name: "surveying-candidates-valid-address" } do
        let(:body) { "1805 Severus dr , 94589" }
        it "sends the next question" do
          last_message = organization.messages.by_recency.first
          expect(last_message.inquiry.present?).to be(true)
        end
      end

      context "that is an address that is too far away", vcr: { cassette_name: "surveying-candidates-address-too-far-away" } do
        let(:body) { "2 Civic Center Drive 94903" }

        it "sends the bad fit notification" do
          last_message = organization.messages.by_recency.first
          notification = last_message.notification
          expect(notification.present?).to be(true)
          expect(notification.template).to eq(organization.survey.bad_fit)
        end
      end

      context "that is unrecognized as an address, but is a naive match", vcr: {cassette_name: "surveying-candidates-only-naive-match"} do
        let(:body) { "This isn't real drive 34029"}
        it "does nothing" do
          last_message = organization.messages.by_recency.first
          expect(last_message.inquiry.present?).to be(false)
          expect(last_message.inbound?).to be(true)
        end
      end

      context "that is unrecognized as an address at all" do
        let(:body) { "adfasdjfadlsk;fsdkf"}
        it "does nothing" do
          last_message = organization.messages.by_recency.first
          expect(last_message.inquiry.present?).to be(false)
          expect(last_message.inbound?).to be(true)
        end
      end
    end
  end
end
