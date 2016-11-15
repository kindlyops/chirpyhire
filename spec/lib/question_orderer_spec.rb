require 'rails_helper'

RSpec.describe QuestionOrderer do
  let(:organization) { create(:organization, :with_account, :with_survey) }
  let(:survey) { organization.survey }
  let!(:questions) { create_list(:question, 3, :document, survey: survey) }
  describe '#reorder' do
    let(:question_count) { survey.questions.count }
    let!(:last_question) { survey.questions.by_priority.last }
    it 'successfully reorders questions' do
      new_question_array = survey.questions.by_priority.map do |question|
        [question.id.to_s, { priority: (question.priority % question_count) + 1 }]
      end
      QuestionOrderer.new(survey).reorder(Hash[new_question_array])
      expect(survey.questions.by_priority.first).to eq(last_question)
    end
  end
end
