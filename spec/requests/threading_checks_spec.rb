require 'rails_helper'

RSpec.feature 'Threading checks', type: :request do
  let(:organization) { create(:organization, phone_number: Faker::PhoneNumber.cell_phone) }
  let!(:location) { create(:location, latitude: 38.145, longitude: -122.255, organization: organization) }
  let(:user) { create(:user, organization: organization) }
  let(:account) { create(:account, user: user) }
  let!(:plan) { create(:plan) }

  before(:each) do
    allow(IntercomSyncerJob).to receive(:perform_later).once
  end

  let!(:registrar) { Registrar.new(account).register }

  let(:candidate) { create(:candidate, organization: organization) }
  let(:unknown_message) { FakeMessaging.inbound_message(candidate, organization, 'I want to startz', format: :text) }
  let(:unknown_message_params) do
    {
      'To' => unknown_message.to,
      'From' => unknown_message.from,
      'Body' => unknown_message.body,
      'MessageSid' => unknown_message.sid
    }
  end

  let(:start_message) { FakeMessaging.inbound_message(candidate, organization, 'START', format: :text) }
  let(:start_message_params) do
    {
      'To' => start_message.to,
      'From' => start_message.from,
      'Body' => start_message.body,
      'MessageSid' => start_message.sid
    }
  end

  context 'candidate sends in unknown message' do
    context 'followed by a start message', vcr: { cassette_name: 'threading-candidates-following-unknown-message' } do
      it 'threads the start message on to the unknown message' do
        post '/twilio/text', params: unknown_message_params
        post '/twilio/text', params: start_message_params
        expect(Message.find_by(sid: unknown_message.sid).child)
          .to eq(Message.find_by(sid: start_message.sid))
      end
    end
  end
end
