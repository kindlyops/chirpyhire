require 'rails_helper'

RSpec.feature 'Surveying Candidates', type: :request do
  let(:organization) { create(:organization, phone_number: Faker::PhoneNumber.cell_phone) }
  let!(:location) { create(:location, latitude: 38.145, longitude: -122.255, organization: organization) }
  let(:user) { create(:user, organization: organization) }
  let(:account) { create(:account, user: user) }
  let!(:plan) { create(:plan) }

  before(:each) do
    allow(IntercomSyncerJob).to receive(:perform_later).once
  end

  let!(:registrar) { Registrar.new(account).register }
  let(:alice) { create(:candidate, organization: organization) }
  let(:start_message) { FakeMessaging.inbound_message(alice, organization, 'START', format: :text) }
  let(:start_message_params) do
    {
      'To' => start_message.to,
      'From' => start_message.from,
      'Body' => start_message.body,
      'MessageSid' => start_message.sid
    }
  end

  context 'when a candidate has texted START' do
    before(:each) do
      post '/twilio/text', params: start_message_params
    end

    context 'and another candidate for the agency has texted START', vcr: { cassette_name: 'surveying-multiple-candidates' } do
      let(:snarf) { create(:candidate, organization: organization) }
      let(:snarf_start_message) { FakeMessaging.inbound_message(snarf, organization, 'START', format: :text) }
      let(:snarf_start_message_params) do
        {
          'To' => snarf_start_message.to,
          'From' => snarf_start_message.from,
          'Body' => snarf_start_message.body,
          'MessageSid' => snarf_start_message.sid
        }
      end

      before(:each) do
        post '/twilio/text', params: snarf_start_message_params
      end

      context 'and the first candidate has responded with an address that is too far away' do
        let(:body) { '2 Civic Center Drive 94903' }
        let(:address_message) { FakeMessaging.inbound_message(alice, organization, body, format: :text) }
        let(:address_message_params) do
          {
            'To' => address_message.to,
            'From' => address_message.from,
            'Body' => address_message.body,
            'MessageSid' => address_message.sid
          }
        end

        before(:each) do
          post '/twilio/text', params: address_message_params
        end

        context 'and the second candidate has responded with a valid address answer' do
          let(:snarf_body) { '1805 Severus dr , 94589' }
          let(:snarf_address_message) { FakeMessaging.inbound_message(snarf, organization, snarf_body, format: :text) }
          let(:snarf_address_message_params) do
            {
              'To' => snarf_address_message.to,
              'From' => snarf_address_message.from,
              'Body' => snarf_address_message.body,
              'MessageSid' => snarf_address_message.sid
            }
          end

          before(:each) do
            post '/twilio/text', params: snarf_address_message_params
          end

          it 'sends the next question to the second candidate' do
            last_message = organization.messages.by_recency.first
            expect(last_message.inquiry.present?).to be(true)
            expect(last_message.user).to eq(snarf.user)
            expect(last_message.inbound?).to eq(false)
          end
        end
      end
    end

    context 'and has submitted an address answer to the first address question' do
      let(:address_message) { FakeMessaging.inbound_message(alice, organization, body, format: :text) }
      let(:address_message_params) do
        {
          'To' => address_message.to,
          'From' => address_message.from,
          'Body' => address_message.body,
          'MessageSid' => address_message.sid
        }
      end

      before(:each) do
        post '/twilio/text', params: address_message_params
      end

      context 'that is a valid address', vcr: { cassette_name: 'surveying-candidates-valid-address' } do
        let(:body) { '1805 Severus dr , 94589' }
        it 'sends the next question' do
          last_message = organization.messages.by_recency.first
          expect(last_message.inquiry.present?).to be(true)
        end
      end

      context 'that is an address that is too far away', vcr: { cassette_name: 'surveying-candidates-address-too-far-away' } do
        let(:body) { '2 Civic Center Drive 94903' }

        it 'sends the bad fit notification' do
          last_message = organization.messages.by_recency.first
          notification = last_message.notification
          expect(notification.present?).to be(true)
          expect(notification.template).to eq(organization.survey.bad_fit)
        end
      end

      context 'that is unrecognized as an address, but is a naive match', vcr: { cassette_name: 'surveying-candidates-only-naive-match' } do
        let(:body) { "This isn't real drive 34029" }
        it 'does not ask the next question' do
          last_message = organization.messages.by_recency.first
          expect(last_message.inquiry.present?).to be(false)
          expect(last_message.inbound?).to be(true)
        end
      end

      context 'that is unrecognized as an address at all' do
        let(:body) { 'adfasdjfadlsk;fsdkf' }
        it 'does not ask the next question' do
          last_message = organization.messages.by_recency.first
          expect(last_message.inquiry.present?).to be(false)
          expect(last_message.inbound?).to be(true)
        end
      end
    end
  end
end
