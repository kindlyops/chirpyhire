require 'rails_helper'

RSpec.describe Teams::SubscriptionsController, type: :controller do
  let!(:team) { create(:team, :account, phone_number: Faker::PhoneNumber.cell_phone) }
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
          }.to change { person.contacts.subscribed.count }.by(1)
        end

        it 'adds the contact to the team' do
          post :create, params: params
          expect(team.contacts).to include(Contact.last)
        end
      end

      context 'with a subscribed contact' do
        let!(:contact) { create(:contact, subscribed: true, person: person, team: team) }

        context 'and an in progress candidacy' do
          before do
            person.candidacy.update(state: :in_progress)
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

          it 'does not create an IceBreakerJob' do
            expect {
              post :create, params: params
            }.not_to have_enqueued_job(IceBreakerJob)
          end

          it 'adds the contact to the team' do
            post :create, params: params
            expect(team.contacts).to include(Contact.last)
          end
        end

        context 'and a completed candidacy' do
          before do
            person.candidacy.update(state: :complete)
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

          it 'does not create an IceBreakerJob' do
            expect {
              post :create, params: params
            }.not_to have_enqueued_job(IceBreakerJob)
          end

          it 'adds the contact to the team' do
            post :create, params: params
            expect(team.contacts).to include(Contact.last)
          end
        end

        context 'and a pending candidacy' do
          before do
            person.candidacy.update(state: :pending)
          end

          it 'does not create an AlreadySubscribedJob' do
            expect {
              post :create, params: params
            }.not_to have_enqueued_job(AlreadySubscribedJob)
          end

          it 'does not create an IceBreakerJob' do
            expect {
              post :create, params: params
            }.not_to have_enqueued_job(IceBreakerJob)
          end

          it 'does create a SurveyorJob' do
            expect {
              post :create, params: params
            }.to have_enqueued_job(SurveyorJob)
          end

          it 'adds the contact to the team' do
            post :create, params: params
            expect(team.contacts).to include(Contact.last)
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

      it 'creates an IceBreakerJob' do
        expect {
          post :create, params: params
        }.to have_enqueued_job(IceBreakerJob)
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

      it 'adds the contact to the team' do
        post :create, params: params
        expect(team.contacts).to include(Contact.last)
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
      let!(:person) { create(:person, :with_candidacy, phone_number: phone_number) }

      context 'without a contact' do
        it 'create an unsubscribed contact' do
          expect {
            delete :destroy, params: params
          }.to change { person.contacts.unsubscribed.count }.by(1)
        end

        it 'adds the contact to the team' do
          post :create, params: params
          expect(team.contacts).to include(Contact.last)
        end
      end

      context 'with a subscribed contact' do
        let!(:contact) { create(:contact, subscribed: true, person: person, team: team) }
        it 'unsubscribes the contact' do
          expect {
            delete :destroy, params: params
          }.to change { contact.reload.subscribed? }.from(true).to(false)
        end

        it 'adds the contact to the team' do
          post :create, params: params
          expect(team.contacts).to include(Contact.last)
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

      it 'creates an unsubscribed contact' do
        expect {
          delete :destroy, params: params
        }.to change { Contact.unsubscribed.count }.by(1)
      end

      it 'adds the contact to the team' do
        post :create, params: params
        expect(team.contacts).to include(Contact.last)
      end
    end
  end
end
