require 'rails_helper'

RSpec.describe Sms::BaseController, type: :controller do
  let(:organization) { create(:organization, phone_number: Faker::PhoneNumber.cell_phone) }
  let(:phone_number) { organization.phone_number }

  describe '#unsolicited_message' do
    context 'without authenticity token' do
      before(:each) do
        ActionController::Base.allow_forgery_protection = true
      end

      after(:each) do
        ActionController::Base.allow_forgery_protection = false
      end

      it 'is OK' do
        post :unsolicited_message, params: { 'MessageSid' => '123', 'To' => phone_number }
        expect(response).to be_ok
      end

      it 'does not create a message' do
        expect {
          post :unsolicited_message, params: { 'MessageSid' => '123', 'To' => phone_number }
        }.not_to change { Message.count }
      end

      it 'creates an UnsolicitedMessageHandlerJob' do
        expect {
          post :unsolicited_message, params: { 'MessageSid' => '123', 'To' => phone_number }
        }.to have_enqueued_job(UnsolicitedMessageHandlerJob)
      end
    end

    it 'sets the Content-Type to text/xml' do
      post :unsolicited_message, params: { 'MessageSid' => '123', 'To' => phone_number }
      expect(response.headers['Content-Type']).to eq('text/xml')
    end

    it 'creates a user' do
      expect {
        post :unsolicited_message, params: { 'MessageSid' => '123', 'To' => phone_number }
      }.to change { organization.users.count }.by(1)
    end
  end
end
