require 'rails_helper'

RSpec.describe Answer::SkinTest do
  let(:contact) { create(:contact) }
  let(:question) { Question::SkinTest.new(contact) }
  subject { Answer::SkinTest.new(question) }

  describe '#valid?' do
    ['yes', 'Yes I have a update skin test', 'no', 'N',
     'Y', 'Yez', 'Yea', 'Yed', 'Yeah', 'Yup', 'Nope', 'Nah'].each do |body|
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

  describe '#attribute' do
    %w(yes Y Yez
       Yea Yed Yeah Yup).each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is true' do
          expect(subject.attribute(message)[:skin_test]).to eq(true)
        end
      end
    end

    %w(N no Nope Nah).each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is false' do
          expect(subject.attribute(message)[:skin_test]).to eq(false)
        end
      end
    end
  end
end
