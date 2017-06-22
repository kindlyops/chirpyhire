require 'rails_helper'

RSpec.describe Teams::MessagesController, type: :controller do
  let(:team) { create(:team, :account, phone_number: Faker::PhoneNumber.cell_phone) }
  let!(:organization) { team.organization }

  describe '#create' do
    context 'new person' do
      let(:params) do
        {
          'To' => team.phone_number,
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

      it 'creates a contact candidacy' do
        expect {
          post :create, params: params
        }.to change { ContactCandidacy.count }.by(1)
      end

      it 'creates a subscribed contact' do
        expect {
          post :create, params: params
        }.to change { Contact.subscribed.count }.by(1)
      end

      it 'adds the contact to the existing team' do
        post :create, params: params
        expect(team.contacts).to include(Contact.last)
      end
    end

    context 'existing person' do
      let!(:person) { create(:person) }

      let(:params) do
        {
          'To' => team.phone_number,
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

      it 'creates a subscribed contact' do
        expect {
          post :create, params: params
        }.to change { person.contacts.subscribed.count }.by(1)
      end

      it 'creates a contact candidacy' do
        expect {
          post :create, params: params
        }.to change { ContactCandidacy.count }.by(1)
      end

      it 'adds the contact to the existing team' do
        post :create, params: params
        expect(team.contacts).to include(Contact.last)
      end
    end
  end
end
