require 'rails_helper'

RSpec.describe Organizations::AnswersController, type: :controller do
  let(:team) { create(:team, :account, :phone_number) }
  let(:organization) { team.organization }
  let(:person) { create(:person) }

  let(:params) do
    {
      'To' => team.phone_number,
      'From' => person.phone_number,
      'Body' => 'Answer',
      'MessageSid' => 'MESSAGE_SID'
    }
  end

  describe '#create' do
    it 'creates a SurveyorAnswerJob' do
      expect {
        post :create, params: params
      }.to have_enqueued_job(SurveyorAnswerJob)
    end
  end
end
