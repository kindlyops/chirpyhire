require 'rails_helper'

RSpec.describe Survey, type: :model do
  describe '#next_unasked_question_for' do
    let(:user) { create(:user) }
    let(:organization) { user.organization }
    let!(:survey) { create(:survey, organization: organization) }

    context 'with questions' do
      let!(:first_question) { create(:question, type: 'AddressQuestion', priority: 1, survey: survey) }
      let!(:second_question) { create(:question, type: 'DocumentQuestion', priority: 2, survey: survey) }

      context 'with no questions asked' do
        it 'is the question with priority 1' do
          expect(survey.next_unasked_question_for(user)).to eq(AddressQuestion.find(first_question.id))
        end
      end

      context 'with the first feature asked' do
        before(:each) do
          message = create(:message, user: user)
          create(:inquiry, message: message, question: first_question)
        end

        it 'is the question with priority 2' do
          expect(survey.next_unasked_question_for(user)).to eq(DocumentQuestion.find(second_question.id))
        end
      end
    end

    context 'without questions' do
      it 'is nil' do
        expect(survey.next_unasked_question_for(user)).to eq(nil)
      end
    end
  end

  describe 'validation' do
    let(:survey) { build(:survey, :with_templates) }

    context 'with multiple active questions' do
      context 'each having a different priority' do
        before(:each) do
          survey.questions_attributes = [attributes_for(:document_question), attributes_for(:document_question)]
        end

        it 'is passes validation' do
          survey.save
          expect(survey.valid?).to eq(true)
        end
      end

      context 'with shared priority' do
        before(:each) do
          survey.questions_attributes = [attributes_for(:document_question, priority: 1), attributes_for(:document_question, priority: 1)]
        end

        it 'fails validation' do
          expect {
            survey.save
          }.to raise_error(ActiveRecord::RecordNotUnique)
        end
      end
    end
  end
end
