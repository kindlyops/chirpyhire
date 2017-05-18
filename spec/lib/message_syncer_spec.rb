require 'rails_helper'

RSpec.describe MessageSyncer do
  let(:organization) { create(:organization, :account) }
  let(:contact) { create(:contact, organization: organization) }
  let(:message_sid) { 'sid' }

  before do
    IceBreaker.call(contact)
  end

  describe 'receipt' do
    before do
      IceBreaker.call(contact)
    end

    context 'receipt requested' do
      subject { MessageSyncer.new(contact, message_sid, receipt: true) }

      it 'calls ReadReceiptsCreator' do
        expect(ReadReceiptsCreator).to receive(:call)

        subject.call
      end
    end

    context 'receipt not requested' do
      subject { MessageSyncer.new(contact, message_sid) }

      it 'does not call ReadReceiptsCreator' do
        expect(ReadReceiptsCreator).not_to receive(:call)

        subject.call
      end
    end
  end
end
