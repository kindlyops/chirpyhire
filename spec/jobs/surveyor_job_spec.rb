require 'rails_helper'

RSpec.describe SurveyorJob do
  let(:contact) { create(:contact) }
  let(:message_sid) { 'MESSAGE_SID' }

  it 'syncs the message' do
    expect(MessageSyncer).to receive(:call).with(contact, message_sid)

    SurveyorJob.perform_now(contact, message_sid)
  end
end
