require 'rails_helper'

RSpec.describe Answer::Availability do
  let(:contact) { create(:contact) }
  let(:question) { Question::Availability.new(contact) }
  subject { Answer::Availability.new(question) }

  describe '#valid?' do
    ['Live in', 'Live-In', 'am', 'pm', 'open', 'A Live in',
     'C bothe', 'A)', 'A.', "A\nJazz", "A.\nJazz", 'B hourly part time'].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is true' do
          expect(subject.valid?(message)).to eq(true)
        end
      end
    end

    ['Definitely, what location are you all hiring for?'].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is false' do
          expect(subject.valid?(message)).to eq(false)
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

    context 'hourly am' do
      ['B hourly', 'am', 'B)', 'B.', 'B hourly part time',
       "B\nJazz", "B.\nJazz"].each do |body|

        let(:message) { create(:message, body: body) }

        it 'is hourly' do
          expect(subject.attribute(message)[:availability]).to eq(:hourly_am)
        end
      end
    end

    context 'hourly pm' do
      ['C hourly', 'pm', 'C)', 'C.', 'C hourly part time',
       "C\nJazz", "C.\nJazz"].each do |body|

        let(:message) { create(:message, body: body) }

        it 'is hourly' do
          expect(subject.attribute(message)[:availability]).to eq(:hourly_pm)
        end
      end
    end

    context 'open' do
      ['D open', 'Open', 'D)', 'D.',
       "D\nJazz", "D.\nJazz"].each do |body|
        let(:message) { create(:message, body: body) }

        it 'is open' do
          expect(subject.attribute(message)[:availability]).to eq(:open)
        end
      end
    end


    context 'invalid' do
      ['Definitely, what location are you all hiring for?', 'hourly', 'no', 'nah', 'nope'].each do |body|
        context body do
          let(:message) { create(:message, body: body) }

          it 'is nil' do
            expect(subject.attribute(message)[:availability]).to eq(nil)
          end
        end
      end
    end
  end
end
