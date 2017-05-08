require 'rails_helper'

RSpec.describe Brokers::SubscriptionsController, type: :controller do
  let(:phone_number) { '+15555555555' }
  let!(:broker) { create(:broker, phone_number: Faker::PhoneNumber.cell_phone) }

  describe '#create' do
    let(:params) do
      {
        'To' => broker.phone_number,
        'From' => phone_number,
        'Body' => 'START',
        'MessageSid' => 'MESSAGE_SID'
      }
    end

    it 'creates a BrokerMessageSyncerJob to log the START message' do
      expect {
        post :create, params: params
      }.to have_enqueued_job(BrokerMessageSyncerJob)
    end

    context 'with a person' do
      let!(:person) { create(:person, :with_broker_candidacy, phone_number: phone_number) }

      context 'without a broker_contact' do
        it 'creates a subscribed broker_contact' do
          expect {
            post :create, params: params
          }.to change { person.broker_contacts.subscribed.count }.by(1)
        end
      end

      context 'with a subscribed broker_contact' do
        let!(:broker_contact) { create(:broker_contact, subscribed: true, person: person, broker: broker) }
        it 'creates an BrokerAlreadySubscribedJob' do
          expect {
            post :create, params: params
          }.to have_enqueued_job(BrokerAlreadySubscribedJob)
        end

        it 'does not create a broker_contact' do
          expect {
            post :create, params: params
          }.not_to change { BrokerContact.count }
        end
      end
    end

    context 'without a person' do
      it 'creates a person' do
        expect {
          post :create, params: params
        }.to change { Person.count }.by(1)
      end

      it 'creates a broker_candidacy' do
        expect {
          post :create, params: params
        }.to change { BrokerCandidacy.count }.by(1)
      end

      it 'creates a subscribed broker_contact' do
        expect {
          post :create, params: params
        }.to change { BrokerContact.subscribed.count }.by(1)
      end

      it 'does not create an BrokerAlreadySubscribedJob' do
        expect {
          post :create, params: params
        }.not_to have_enqueued_job(BrokerAlreadySubscribedJob)
      end

      it 'does create an BrokerSurveyorJob' do
        expect {
          post :create, params: params
        }.to have_enqueued_job(BrokerSurveyorJob)
      end
    end
  end

  describe '#destroy' do
    let(:params) do
      {
        'To' => broker.phone_number,
        'From' => phone_number,
        'Body' => 'STOP',
        'MessageSid' => 'MESSAGE_SID'
      }
    end

    it 'creates a BrokerMessageSyncerJob to log the STOP message' do
      expect {
        delete :destroy, params: params
      }.to have_enqueued_job(BrokerMessageSyncerJob)
    end

    context 'with a person' do
      let!(:person) { create(:person, :with_broker_candidacy, phone_number: phone_number) }

      context 'without a broker_contact' do
        it 'create an unsubscribed broker_contact' do
          expect {
            delete :destroy, params: params
          }.to change { person.broker_contacts.unsubscribed.count }.by(1)
        end
      end

      context 'with a subscribed broker_contact' do
        let!(:broker_contact) { create(:broker_contact, subscribed: true, person: person, broker: broker) }
        it 'unsubscribes the broker_contact' do
          expect {
            delete :destroy, params: params
          }.to change { broker_contact.reload.subscribed? }.from(true).to(false)
        end
      end
    end

    context 'without a person' do
      it 'creates a person' do
        expect {
          delete :destroy, params: params
        }.to change { Person.count }.by(1)
      end

      it 'creates a broker_candidacy' do
        expect {
          delete :destroy, params: params
        }.to change { BrokerCandidacy.count }.by(1)
      end

      it 'creates an unsubscribed broker_contact' do
        expect {
          delete :destroy, params: params
        }.to change { BrokerContact.unsubscribed.count }.by(1)
      end
    end
  end
end
