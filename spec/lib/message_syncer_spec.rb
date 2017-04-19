require 'rails_helper'

RSpec.describe MessageSyncer do
  let(:organization) { create(:organization) }
  let(:contact) { create(:contact, organization: organization) }
  let(:person) { contact.person }
  let(:message_sid) { 'sid' }

  before do
    IceBreaker.call(contact)
  end

  describe 'receipt' do
    context 'receipt requested' do
      subject { MessageSyncer.new(person, organization, message_sid, receipt: true) }

      it 'calls ReadReceiptsCreator' do
        expect(ReadReceiptsCreator).to receive(:call)

        subject.call
      end
    end

    context 'receipt not requested' do
      subject { MessageSyncer.new(person, organization, message_sid) }

      it 'does not call ReadReceiptsCreator' do
        expect(ReadReceiptsCreator).not_to receive(:call)

        subject.call
      end
    end
  end
end
