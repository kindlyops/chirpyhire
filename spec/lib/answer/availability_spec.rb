require 'rails_helper'

RSpec.describe Answer::Availability do
  let(:contact) { create(:contact) }
  let(:question) { Question::Availability.new(contact) }
  subject { Answer::Availability.new(question) }

  describe '#valid?' do
    ['Live in', 'Live-In', 'hourly', 'both', 'no', 'nah', 'nope', 'A Live in',
     'C bothe', 'A)', 'A.', "A\nJazz", "A.\nJazz"].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is true' do
          expect(subject.valid?(message)).to eq(true)
        end
      end
    end
  end

  describe '#attribute' do
    context 'live_in' do
      ['A live in', 'live in', 'A)', 'A.',
       "A\nJazz", "A.\nJazz", 'Live-In'].each do |body|

        let(:message) { create(:message, body: body) }

        it 'is live_in' do
          expect(subject.attribute(message)[:availability]).to eq(:live_in)
        end
      end
    end

    context 'hourly' do
      ['B hourly', 'Hourly', 'B)', 'B.',
       "B\nJazz", "B.\nJazz"].each do |body|

        let(:message) { create(:message, body: body) }

        it 'is hourly' do
          expect(subject.attribute(message)[:availability]).to eq(:hourly)
        end
      end
    end

    context 'both' do
      ['C both', 'Both', 'C)', 'C.',
       "C\nJazz", "C.\nJazz"].each do |body|
        let(:message) { create(:message, body: body) }

        it 'is both' do
          expect(subject.attribute(message)[:availability]).to eq(:both)
        end
      end
    end

    context 'no availability' do
      ['no', 'nope', 'N', 'nah', 'D both', 'Both', 'D)', 'D.',
       "D\nJazz", "D.\nJazz", 'No Availability'].each do |body|
        let(:message) { create(:message, body: body) }

        it 'is no' do
          expect(subject.attribute(message)[:availability]).to eq(:no_availability)
        end
      end
    end
  end
end
