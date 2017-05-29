require 'rails_helper'

RSpec.describe Answer::CprFirstAid do
  let(:contact) { create(:contact) }
  let(:question) { Question::CprFirstAid.new(contact) }
  subject { Answer::CprFirstAid.new(question) }

  describe '#valid?' do
    ['yes', 'Yes I have a update cpr', 'yup i have my cpr',
     'nope i do not have my cpr', 'no', 'N', 'Y', 'Yez',
     'Yea', 'Yed', 'Yeah', 'Yup', 'Nope', 'Nah'].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is true' do
          expect(subject.valid?(message)).to eq(true)
        end
      end
    end

    ['yesterday...', 'nowhere man', 'I can get them in the matter of days',
     'not sure I will like', 'OK talk soon'].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is false' do
          expect(subject.valid?(message)).to eq(false)
        end
      end
    end
  end

  describe '#attribute' do
    ['yes', 'Yes I have a update cpr', 'yup i have my cpr', 'Y', 'Yez',
     'Yea', 'Yed', 'Yeah', 'Yup', 'A'].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is true' do
          expect(subject.attribute(message)[:cpr_first_aid]).to eq(true)
        end
      end
    end

    %w[N no Nope Nah B].push('nope i do not have my cpr').each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is false' do
          expect(subject.attribute(message)[:cpr_first_aid]).to eq(false)
        end
      end
    end

    context 'invalid' do
      %w[nobody yesterday]
        .push('Im willing to travel', 'I can get them in the matter of days').each do |body|
        context body do
          let(:message) { create(:message, body: body) }

          it 'is nil' do
            expect(subject.attribute(message)[:cpr_first_aid]).to eq(nil)
          end
        end
      end
    end
  end
end
