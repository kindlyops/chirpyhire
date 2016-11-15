require 'rails_helper'

RSpec.feature 'Surveying Candidates', type: :request do
  let(:organization) { create(:organization, phone_number: Faker::PhoneNumber.cell_phone) }
  let!(:location) { create(:location, latitude: 38.145, longitude: -122.255, organization: organization) }
  let(:user) { create(:user, organization: organization) }
  let(:account) { create(:account, user: user) }
  let!(:plan) { create(:plan) }

  let!(:registrar) { Registrar.new(account).register }
  let(:sender_object) { Struct.new(:phone_number) }
  let(:alice_sender_object) { sender_object.new('+12222222222') }
  let(:start_message) { FakeMessaging.inbound_message(alice_sender_object, organization, 'START', format: :text) }
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
      let(:snarf_sender_object) { sender_object.new('+133333333333') }

      let(:snarf_start_message) { FakeMessaging.inbound_message(snarf_sender_object, organization, 'START', format: :text) }
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
      let(:snarf) { create(:candidate, organization: organization) }

      context 'and the first candidate has responded with an invalid zipcode' do
        let(:body) { '99999' }
        let(:address_message) { FakeMessaging.inbound_message(alice_sender_object, organization, body, format: :text) }
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

        context 'and the second candidate has responded with a valid zipcode' do
          let(:snarf_body) { location.zipcode }
          let(:snarf_address_message) { FakeMessaging.inbound_message(snarf_sender_object, organization, snarf_body, format: :text) }
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
            expect(last_message.user).to eq(User.find_by(phone_number: snarf_sender_object.phone_number))
            expect(last_message.inbound?).to eq(false)
          end
        end
      end
    end

    context 'and has submitted an address answer to the first address question' do
      let(:address_message) { FakeMessaging.inbound_message(alice_sender_object, organization, body, format: :text) }
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

      context 'that is a valid zipcode', vcr: { cassette_name: 'surveying-candidates-valid-address' } do
        let(:body) { location.zipcode }
        it 'sends the next question' do
          last_message = organization.messages.by_recency.first
          expect(last_message.inquiry.present?).to be(true)
        end
      end

      context 'an invalid zipcode', vcr: { cassette_name: 'surveying-candidates-address-too-far-away' } do
        let(:body) { '99999' }

        it 'sends the bad fit notification' do
          last_message = organization.messages.by_recency.first
          notification = last_message.notification
          expect(notification.present?).to be(true)
          expect(notification.template).to eq(organization.survey.bad_fit)
        end
      end

      context 'that is unrecognized as a zipcode at all' do
        let(:body) { 'adfasdjfadlsk;fsdkf' }
        it 'does not ask the next question' do
          last_message = organization.messages.by_recency.first
          expect(last_message.inquiry.present?).to be(false)
          expect(last_message.inbound?).to be(false)
          expect(last_message.body).to(
            eq(organization.survey.not_understood.body)
          )
        end
      end
    end
  end
end
