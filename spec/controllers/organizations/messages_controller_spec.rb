require 'rails_helper'

RSpec.describe Organizations::MessagesController, type: :controller do
  let(:organization) { create(:organization, phone_number: Faker::PhoneNumber.cell_phone) }
  let(:person) { create(:person, :with_candidacy) }

  let(:params) do
    {
      'To' => organization.phone_number,
      'From' => person.phone_number,
      'Body' => 'Answer',
      'MessageSid' => 'MESSAGE_SID'
    }
  end

  describe '#create' do
    it 'creates a MessageSyncerJob' do
      expect {
        post :create, params: params
      }.to have_enqueued_job(MessageSyncerJob)
    end
  end
end
