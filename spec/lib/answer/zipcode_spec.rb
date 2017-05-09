require 'rails_helper'

RSpec.describe Answer::Zipcode do
  let(:contact) { create(:contact) }
  let(:question) { Question::Zipcode.new(contact) }
  subject { Answer::Zipcode.new(question) }

  describe '#valid?' do
    context '5 digits' do
      context 'valid zipcode' do
        let(:message) { create(:message, body: '30342') }

        it 'is true' do
          expect(subject.valid?(message)).to eq(true)
        end
      end

      context 'not a zipcode' do
        let(:message) { create(:message, body: '11111') }
        it 'is false' do
          expect(subject.valid?(message)).to eq(false)
        end
      end
    end

    context 'not 5 digits' do
      let(:message) { create(:message, body: '12312009') }

      it 'is false' do
        expect(subject.valid?(message)).to eq(false)
      end
    end
  end

  describe '#attribute' do
    context '5 digits' do
      context 'valid zipcode' do
        let(:message) { create(:message, body: '30342') }

        it 'is true' do
          expect(subject.attribute(message)[:zipcode]).to eq('30342')
        end
      end
    end
  end

  describe '#format' do
    let(:person) { contact.person }
    let!(:message) { create(:message, sender: person, body: '30342') }

    context 'zipcode present' do
      let!(:zipcode) { create(:zipcode, '30342'.to_sym) }

      it 'sets the zipcode on the person' do
        expect {
          subject.format(message)
        }.to change { person.reload.zipcode }.from(nil).to(zipcode)
      end
    end

    context 'zipcode not present' do
      it 'calls the ZipcodeFetcherJob' do
        expect {
          subject.format(message)
        }.to have_enqueued_job(ZipcodeFetcherJob)
      end
    end
  end
end
