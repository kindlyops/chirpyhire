require 'rails_helper'

RSpec.describe Organizations::MessagesController, type: :controller do
  let!(:organization) { create(:organization, phone_number: Faker::PhoneNumber.cell_phone) }

  describe '#create' do
    context 'new person' do
      let(:params) do
        {
          'To' => organization.phone_number,
          'From' => '+14041234567',
          'Body' => 'Answer',
          'MessageSid' => 'MESSAGE_SID'
        }
      end

      it 'creates a person' do
        expect {
          post :create, params: params
        }.to change { Person.count }.by(1)
      end

      it 'creates a candidacy' do
        expect {
          post :create, params: params
        }.to change { Candidacy.count }.by(1)
      end

      it 'creates a subscribed contact' do
        expect {
          post :create, params: params
        }.to change { Contact.subscribed.count }.by(1)
      end
    end

    context 'existing person' do
      let!(:person) { create(:person, :with_candidacy) }

      let(:params) do
        {
          'To' => organization.phone_number,
          'From' => person.phone_number,
          'Body' => 'Answer',
          'MessageSid' => 'MESSAGE_SID'
        }
      end

      it 'creates a MessageSyncerJob' do
        expect {
          post :create, params: params
        }.to have_enqueued_job(MessageSyncerJob)
      end

      it 'does not create a person' do
        expect {
          post :create, params: params
        }.not_to change { Person.count }
      end

      it 'does not create a candidacy' do
        expect {
          post :create, params: params
        }.not_to change { Candidacy.count }
      end

      it 'creates a subscribed contact' do
        expect {
          post :create, params: params
        }.to change { person.contacts.subscribed.count }.by(1)
      end
    end
  end
end
