require 'rails_helper'

RSpec.describe IceBreaker do
  let(:contact) { create(:contact) }
  let(:team) { contact.team }
  let(:organization) { contact.organization }

  subject { IceBreaker.new(contact) }

  describe '#call' do
    it 'creates a conversation and ties it to the contact team inbox' do
      expect {
        subject.call
      }.to change { team.conversations.count }.by(1)
    end
  end
end
