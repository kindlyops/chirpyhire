require 'rails_helper'

RSpec.describe SurveyorJob do
  let(:contact) { create(:contact) }
  let(:message_sid) { 'MESSAGE_SID' }
  let(:message) { create(:message, sid: message_sid) }

  it 'syncs the message' do
    expect(MessageSyncer).to receive(:call).with(contact, message_sid).and_return(message)

    SurveyorJob.perform_now(contact, message_sid)
  end
end
