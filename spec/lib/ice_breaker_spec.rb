require 'rails_helper'

RSpec.describe IceBreaker do
  let(:organization) { create(:organization, :team) }
  let(:phone_number) { organization.phone_numbers.first }
  let(:team) { organization.teams.first }
  let(:contact) { create(:contact, organization: organization) }

  subject { IceBreaker.new(contact, phone_number) }

  describe '#call' do
    context 'with assignment rule between phone_number and team inbox' do
      it 'creates a conversation and ties it to the contact team inbox' do
        expect {
          subject.call
        }.to change { team.conversations.count }.by(1)
      end
    end
  end
end
