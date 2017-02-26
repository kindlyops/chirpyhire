require 'rails_helper'

RSpec.describe Answer::CprFirstAid do
  let(:contact) { create(:contact) }
  let(:question) { Question::CprFirstAid.new(contact) }
  subject { Answer::CprFirstAid.new(question) }

  describe '#valid?' do
    ['yes', 'Yes I have a update cpr', 'no',
     "I'm not cpr certified", 'N', 'Y', 'Yez', 'Yea',
     'Yed', 'Yeah', 'Yup', 'Nope', 'Nah'].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is true' do
          expect(subject.valid?(message)).to eq(true)
        end
      end
    end

    ['yesterday...', 'nowhere man'].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is false' do
          expect(subject.valid?(message)).to eq(false)
        end
      end
    end
  end

  describe 'attribute' do
    ['yes', 'Yes I have a update cpr', 'Y', 'Yez',
     'Yea', 'Yed', 'Yeah', 'Yup'].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is true' do
          expect(subject.attribute(message)[:cpr_first_aid]).to eq(true)
        end
      end
    end

    ['N', 'no', "I'm not cpr certified", 'Nope', 'Nah'].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is false' do
          expect(subject.attribute(message)[:cpr_first_aid]).to eq(false)
        end
      end
    end
  end
end
