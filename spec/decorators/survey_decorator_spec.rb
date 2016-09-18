require 'rails_helper'

RSpec.describe SurveyDecorator do
  let(:model) { create(:survey) }
  let(:survey) { described_class.new(model) }

  describe '#questions' do
    let!(:inactive_question) { create(:choice_question, survey: survey, status: 1, priority: 1) }
    let!(:current_question) { create(:choice_question, survey: survey, status: 0, priority: 2) }

    context 'with inactive questions' do
      context 'that have a higher priority than existing questions' do
        it 'returns the deleted questions last' do
          expect(survey.questions).to eq([current_question, inactive_question])
        end
      end
    end
  end
end
