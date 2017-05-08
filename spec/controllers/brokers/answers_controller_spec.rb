require 'rails_helper'

RSpec.describe Brokers::AnswersController, type: :controller do
  let(:broker) { create(:broker, phone_number: Faker::PhoneNumber.cell_phone) }
  let(:person) { create(:person, :with_broker_candidacy) }

  let(:params) do
    {
      'To' => broker.phone_number,
      'From' => person.phone_number,
      'Body' => 'Answer',
      'MessageSid' => 'MESSAGE_SID'
    }
  end

  describe '#create' do
    it 'creates a BrokerSurveyorAnswerJob' do
      expect {
        post :create, params: params
      }.to have_enqueued_job(BrokerSurveyorAnswerJob)
    end
  end
end
