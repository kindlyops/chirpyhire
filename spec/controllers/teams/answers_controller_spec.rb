require 'rails_helper'

RSpec.describe Teams::AnswersController, type: :controller do
  let(:team) { create(:team, phone_number: Faker::PhoneNumber.cell_phone) }
  let(:person) { create(:person, :with_candidacy) }

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
