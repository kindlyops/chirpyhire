require 'rails_helper'

RSpec.describe AlreadySubscribedJob do
  let(:contact) { create(:contact) }
  let(:message_sid) { 'MESSAGE_SID' }

  it 'syncs the message' do
    expect(MessageSyncer).to receive(:call).with(contact, message_sid)

    AlreadySubscribedJob.perform_now(contact, message_sid)
  end
end
