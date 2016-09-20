require 'rails_helper'

RSpec.describe ChoiceQuestion, type: :model do
  it { should validate_presence_of(:choice_question_options) }

  describe '.extract' do
    let(:message) { create(:message, body: 'B)') }
    let(:question) { create(:choice_question, choice_question_options_attributes: [{ letter: 'a', text: 'original A' }]) }
    let!(:option_a) { question.choice_question_options.first }
    let!(:option_b) { question.choice_question_options.find_or_create_by(letter: 'b', text: 'original B') }
    let!(:inquiry) { create(:inquiry, question: question) }

    context 'in which the option selected at the time the inquiry has been changed' do
      let(:choice_hash) do
        {
          choice_option: 'original B',
          child_class: 'choice'
        }
      end

      it 'returns a choice hash' do
        expect(ChoiceQuestion.extract(message, inquiry)).to eq(choice_hash)
      end

      with_versioning do
        it 'can still lookup the old text value' do
          question.update(text: 'FooBar', choice_question_options_attributes: [{ id: option_b.id, text: 'new B' }])
          result_hash = ChoiceQuestion.extract(message, inquiry)
          expect(result_hash[:choice_option]).to eq('original B')
        end
      end
    end
  end

  describe 'instance methods' do
    let!(:organization) { create(:organization) }
    let!(:message) { create(:message, body: 'A) ') }
    let(:survey) { create(:survey) }

    let!(:choice_question) {
      create(:choice_question, text: 'What is your availability?', survey: survey,
                               choice_question_options_attributes: [
                                 { letter: 'a', text: 'Live-in' }
                               ])
    }
    let!(:additional_options) do
      [
        choice_question.choice_question_options.create(letter: 'b', text: 'Hourly'),
        choice_question.choice_question_options.create(letter: 'c', text: 'Both')
      ]
    end

    describe '#in_memory_sorted_options' do
      it 'sorts the options by letter' do
        expect(choice_question.in_memory_sorted_options.map(&:letter)).to eq(%w(a b c))
      end
    end

    describe '#formatted_text' do
      let(:question) do
        <<-question
What is your availability?

a) Live-in
b) Hourly
c) Both

Please reply with just the letter a, b, or c.
    question
      end

      it 'returns a question' do
        expect(choice_question.formatted_text).to eq(question)
      end
    end
  end
end
