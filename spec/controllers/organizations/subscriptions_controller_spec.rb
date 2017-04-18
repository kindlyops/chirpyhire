require 'rails_helper'

RSpec.describe Organizations::SubscriptionsController, type: :controller do
  let!(:organization) { create(:organization, phone_number: Faker::PhoneNumber.cell_phone) }
  let(:phone_number) { '+15555555555' }

  describe '#create' do
    let(:params) do
      {
        'To' => organization.phone_number,
        'From' => phone_number,
        'Body' => 'START',
        'MessageSid' => 'MESSAGE_SID'
      }
    end

    it 'creates a MessageSyncerJob to log the START message' do
      expect {
        post :create, params: params
      }.to have_enqueued_job(MessageSyncerJob)
    end

    context 'with a person' do
      let!(:person) { create(:person, :with_candidacy, phone_number: phone_number) }

      context 'without a contact' do
        it 'creates a subscribed contact' do
          expect {
            post :create, params: params
          }.to change { person.contacts.count }.by(1)
        end
      end

      context 'with a contact' do
        let!(:contact) { create(:contact, person: person, organization: organization) }
        it 'creates an AlreadySubscribedJob' do
          expect {
            post :create, params: params
          }.to have_enqueued_job(AlreadySubscribedJob)
        end
      end
    end

    context 'without a person' do
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
    end
  end

  describe '#destroy' do
    let(:params) do
      {
        'To' => organization.phone_number,
        'From' => phone_number,
        'Body' => 'STOP',
        'MessageSid' => 'MESSAGE_SID'
      }
    end

    it 'creates a MessageSyncerJob to log the STOP message' do
      expect {
        delete :destroy, params: params
      }.to have_enqueued_job(MessageSyncerJob)
    end

    context 'with a person' do
      let!(:person) { create(:person, :with_candidacy, phone_number: phone_number) }

      context 'without a contact' do
        it 'creates an NotSubscribedJob' do
          expect {
            delete :destroy, params: params
          }.to have_enqueued_job(NotSubscribedJob)
        end
      end

      context 'with a subscribed contact' do
        let!(:contact) { create(:contact, person: person, organization: organization) }
        it 'unsubscribes the contact' do
          expect {
            delete :destroy, params: params
          }.to change { contact.reload.subscribed? }.from(true).to(false)
        end
      end
    end

    context 'without a person' do
      it 'creates a person' do
        expect {
          delete :destroy, params: params
        }.to change { Person.count }.by(1)
      end

      it 'creates a candidacy' do
        expect {
          delete :destroy, params: params
        }.to change { Candidacy.count }.by(1)
      end
    end
  end
end
