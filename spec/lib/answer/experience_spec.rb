require 'rails_helper'

RSpec.describe Answer::Experience do
  let(:contact) { create(:contact) }
  let(:question) { Question::Experience.new(contact) }
  subject { Answer::Experience.new(question) }

  describe '#valid?' do
    ['0', '3', '6', '2', 'new to caregiving', '0-1', '0 - 1',
     '6 or more', '0- 1', '0 -1', 'A.', "A\nJazz",
     'B)', 'B 2 years'].each do |body|
      let(:message) { create(:message, body: body) }

      it 'is true' do
        expect(subject.valid?(message)).to eq(true)
      end
    end
  end

  describe 'attribute' do
    context '0 - 1' do
      ['1', '0- 1', '0 -1', '0-1', '0 - 1', 'A.', "A\nJazz"].each do |body|
        let(:message) { create(:message, body: body) }

        it 'is less_than_one' do
          expect(subject.attribute(message)[:experience]).to eq(:less_than_one)
        end
      end
    end

    context '1 - 5' do
      ['B)', 'B 2 years', '2', '3', '4', '5'].each do |body|
        let(:message) { create(:message, body: body) }

        it 'is one_to_five' do
          expect(subject.attribute(message)[:experience]).to eq(:one_to_five)
        end
      end
    end

    context '6 or more' do
      ['C)', 'C 12 years', '30', '7', '10', '11'].each do |body|
        let(:message) { create(:message, body: body) }

        it 'is six_or_more' do
          expect(subject.attribute(message)[:experience]).to eq(:six_or_more)
        end
      end
    end

    context 'New to caregiving' do
      ['0', 'D.', "D\nJazz"].each do |body|
        let(:message) { create(:message, body: body) }

        it 'is no_experience' do
          expect(subject.attribute(message)[:experience]).to eq(:no_experience)
        end
      end
    end
  end
end
