require 'rails_helper'

RSpec.describe Organizations::MessagesController, type: :controller do
  let!(:organization) { create(:organization, :account, :recruiting_ad, phone_number: Faker::PhoneNumber.cell_phone) }

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

      context 'without a team' do
        it 'creates a team' do
          expect {
            post :create, params: params
          }.to change { organization.reload.teams.count }.by(1)
        end

        it 'adds the contact to the existing team' do
          post :create, params: params
          expect(organization.teams.first.contacts).to include(Contact.last)
        end
      end

      context 'with a team' do
        before do
          create(:team, organization: organization)
        end

        it 'does not create a team' do
          expect {
            post :create, params: params
          }.not_to change { organization.reload.teams.count }
        end

        it 'adds the contact to the existing team' do
          post :create, params: params
          expect(organization.teams.first.contacts).to include(Contact.last)
        end
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

      context 'without a team' do
        it 'creates a team' do
          expect {
            post :create, params: params
          }.to change { organization.reload.teams.count }.by(1)
        end

        it 'adds the contact to the existing team' do
          post :create, params: params
          expect(organization.teams.first.contacts).to include(Contact.last)
        end
      end

      context 'with a team' do
        before do
          create(:team, organization: organization)
        end

        it 'does not create a team' do
          expect {
            post :create, params: params
          }.not_to change { organization.reload.teams.count }
        end

        it 'adds the contact to the existing team' do
          post :create, params: params
          expect(organization.teams.first.contacts).to include(Contact.last)
        end
      end
    end
  end
end
