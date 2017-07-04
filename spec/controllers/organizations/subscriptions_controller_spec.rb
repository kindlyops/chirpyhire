require 'rails_helper'

RSpec.describe Organizations::SubscriptionsController, type: :controller do
  let!(:team) { create(:team, :account, :phone_number) }
  let(:organization) { team.organization }
  let(:phone_number) { '+15555555555' }

  describe '#create' do
    let(:params) do
      {
        'To' => team.phone_number,
        'From' => phone_number,
        'Body' => 'START',
        'MessageSid' => 'MESSAGE_SID'
      }
    end

    context 'with a person' do
      let!(:person) { create(:person, phone_number: phone_number) }

      context 'without a contact' do
        it 'creates a subscribed contact' do
          expect {
            post :create, params: params
          }.to change { person.contacts.subscribed.count }.by(1)
        end

        it 'creates a ContactCandidacy' do
          expect {
            post :create, params: params
          }.to change { ContactCandidacy.count }.by(1)
        end

        it 'adds the contact to the organization' do
          post :create, params: params
          expect(organization.contacts).to include(Contact.last)
        end
      end

      context 'with a subscribed contact' do
        let!(:contact) { create(:contact, subscribed: true, person: person, organization: organization) }

        context 'and an in progress candidacy' do
          before do
            contact.contact_candidacy.update(state: :in_progress)
          end

          it 'creates an AlreadySubscribedJob' do
            expect {
              post :create, params: params
            }.to have_enqueued_job(AlreadySubscribedJob)
          end

          it 'does not create a contact' do
            expect {
              post :create, params: params
            }.not_to change { Contact.count }
          end

          it 'adds the contact to the organization' do
            post :create, params: params
            expect(organization.contacts).to include(Contact.last)
          end
        end

        context 'and a completed candidacy' do
          before do
            contact.contact_candidacy.update(state: :complete)
          end

          it 'creates an AlreadySubscribedJob' do
            expect {
              post :create, params: params
            }.to have_enqueued_job(AlreadySubscribedJob)
          end

          it 'marks the contact as screened' do
            post :create, params: params
            expect(Contact.last.screened?).to eq(true)
          end

          it 'does not create a contact' do
            expect {
              post :create, params: params
            }.not_to change { Contact.count }
          end

          it 'adds the contact to the organization' do
            post :create, params: params
            expect(organization.contacts).to include(Contact.last)
          end
        end

        context 'and a pending candidacy' do
          before do
            contact.contact_candidacy.update(state: :pending)
          end

          it 'does not create an AlreadySubscribedJob' do
            expect {
              post :create, params: params
            }.not_to have_enqueued_job(AlreadySubscribedJob)
          end

          it 'does create a SurveyorJob' do
            expect {
              post :create, params: params
            }.to have_enqueued_job(SurveyorJob)
          end

          it 'adds the contact to the organization' do
            post :create, params: params
            expect(organization.contacts).to include(Contact.last)
          end
        end
      end
    end

    context 'without a person' do
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

      it 'does not create an AlreadySubscribedJob' do
        expect {
          post :create, params: params
        }.not_to have_enqueued_job(AlreadySubscribedJob)
      end

      it 'does create an SurveyorJob' do
        expect {
          post :create, params: params
        }.to have_enqueued_job(SurveyorJob)
      end

      it 'adds the contact to the organization' do
        post :create, params: params
        expect(organization.contacts).to include(Contact.last)
      end
    end
  end

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

        it 'create a ContactCandidacy' do
          expect {
            delete :destroy, params: params
          }.to change { ContactCandidacy.count }.by(1)
        end

        it 'adds the contact to the organization' do
          delete :destroy, params: params
          expect(organization.contacts).to include(Contact.last)
        end
      end

      context 'with a subscribed contact' do
        let!(:contact) { create(:contact, subscribed: true, person: person, organization: organization) }
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

      it 'creates a contact candidacy' do
        expect {
          delete :destroy, params: params
        }.to change { ContactCandidacy.count }.by(1)
      end

      it 'creates an unsubscribed contact' do
        expect {
          delete :destroy, params: params
        }.to change { Contact.unsubscribed.count }.by(1)
      end

      it 'adds the contact to the organization' do
        delete :destroy, params: params
        expect(organization.contacts).to include(Contact.last)
      end
    end
  end
end
