require 'rails_helper'

RSpec.describe Answer::Transportation do
  let(:contact) { create(:contact) }
  let(:question) { Question::Transportation.new(contact) }
  subject { Answer::Transportation.new(question) }

  describe '#valid?' do
    ['Personal', 'Public', 'no transportation', 'Personal Transportation',
     'no', 'nah', 'nope', 'A personal', 'C no', 'B)',
     'A.', "A\nJazz", "B.\nJazz"].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is true' do
          expect(subject.valid?(message)).to eq(true)
        end
      end
    end
  end

  describe 'attribute' do
    context 'personal_transportation' do
      ['A personal', 'personal', 'A)', 'A.',
       "A\nJazz", "A.\nJazz", 'Live-In'].each do |body|

        let(:message) { create(:message, body: body) }

        it 'is personal_transportation' do
          expect(subject.attribute(message)[:certification]).to eq(:personal_transportation)
        end
      end
    end

    context 'public_transportation' do
      ['B public transportation', 'Public', 'B)', 'B.',
       "B\nJazz", "B.\nJazz"].each do |body|

        let(:message) { create(:message, body: body) }

        it 'is public_transportation' do
          expect(subject.attribute(message)[:certification]).to eq(:public_transportation)
        end
      end
    end

    context 'no_transportation' do
      ['C no transportation', 'No', 'C)', 'C.',
       "C\nJazz", "C.\nJazz"].each do |body|
        let(:message) { create(:message, body: body) }

        it 'is no_transportation' do
          expect(subject.attribute(message)[:certification]).to eq(:no_transportation)
        end
      end
    end
  end
end
