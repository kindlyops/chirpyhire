require 'rails_helper'

RSpec.describe Organizations::SubscriptionsController, type: :controller do
  let!(:team) { create(:team, :account, :phone_number) }
  let(:organization) { team.organization }
  let!(:stage) { create(:contact_stage, organization: organization) }
  let(:phone_number) { '+15555555555' }

  describe '#destroy' do
    let(:params) do
      {
        'To' => team.phone_number,
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
      let!(:person) { create(:person, phone_number: phone_number) }

      context 'without a contact' do
        it 'create an unsubscribed contact' do
          expect {
            delete :destroy, params: params
          }.to change { person.contacts.unsubscribed.count }.by(1)
        end

        it 'sets the stage of the contact as the first stage' do
          delete :destroy, params: params
          expect(person.contacts.last.stage).to eq(stage)
        end

        it 'adds the contact to the organization' do
          delete :destroy, params: params
          expect(organization.contacts).to include(Contact.last)
        end
      end

      context 'with a subscribed contact' do
        let!(:contact) { create(:contact, subscribed: true, phone_number: phone_number, person: person, organization: organization) }
        it 'unsubscribes the contact' do
          expect {
            delete :destroy, params: params
          }.to change { contact.reload.subscribed? }.from(true).to(false)
        end

        it 'adds the contact to the organization' do
          delete :destroy, params: params
          expect(organization.contacts).to include(Contact.last)
        end
      end
    end

    context 'without a person' do
      it 'creates a person' do
        expect {
          delete :destroy, params: params
        }.to change { Person.count }.by(1)
      end

      it 'creates an unsubscribed contact' do
        expect {
          delete :destroy, params: params
        }.to change { Contact.unsubscribed.count }.by(1)
      end

      it 'sets the stage of the contact as the first stage' do
        delete :destroy, params: params
        expect(Contact.last.stage).to eq(stage)
      end

      it 'adds the contact to the organization' do
        delete :destroy, params: params
        expect(organization.contacts).to include(Contact.last)
      end
    end
  end
end
