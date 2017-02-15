require 'rails_helper'

RSpec.describe AddressQuestion, type: :model do
  let(:survey) { create(:survey) }
  let(:question) { create(:address_question, survey: survey) }

  describe '#rejects?' do
    let(:candidate) { create(:candidate) }

    context 'without geofence' do
      it 'returns false' do
        expect(question.rejects?(candidate)).to eq(false)
      end
    end

    context 'with geofence' do
      let(:question) { create(:address_question, survey: survey) }
      let(:latitude) { 12.345678 }
      let(:longitude) { 87.654321 }
      let!(:address_question_option) { create(:address_question_option, latitude: latitude, longitude: longitude, address_question: question) }
      let(:candidate) { create(:candidate, :with_address) }

      context 'and the candidates coordinates are within the geofence' do
        before(:each) do
          existing_properties = candidate.address_feature.properties
          candidate.address_feature.update(properties: existing_properties.merge(latitude: latitude, longitude: longitude))
        end

        it 'returns false' do
          expect(question.rejects?(candidate)).to eq(false)
        end
      end

      context 'and the candidates coordinates are outside the geofence' do
        before(:each) do
          existing_properties = candidate.address_feature.properties
          candidate.address_feature.update(properties: existing_properties.merge(latitude: 38.918138, longitude: -77.241273))
        end

        it 'is true' do
          expect(question.rejects?(candidate)).to eq(true)
        end
      end
    end
  end

  describe '.extract' do
    let(:address) do
      FakeAddress.new(
        '1000 East Market Street, Charlottesville, VA, USA',
        38.028531,
        -78.473088,
        'USA',
        'Charlottesville',
        '22902'
      )
    end

    let(:message) { create(:message) }

    let(:address_hash) do
      { city: 'Charlottesville',
        address: '1000 East Market Street, Charlottesville, VA, USA',
        country: 'USA',
        latitude: 38.028531,
        longitude: -78.473088,
        postal_code: '22902',
        child_class: AddressQuestion.child_class_property }
    end

    before(:each) do
      allow(message).to receive(:address).and_return(address)
    end

    it 'returns an address hash' do
      expect(AddressQuestion.extract(message, double(question: double))).to eq(address_hash)
    end
  end

  describe '#geofenced?' do
    context 'with geofence' do
      before(:each) do
        create(:address_question_option, address_question: question)
      end

      it 'is true' do
        expect(question.geofenced?).to eq(true)
      end
    end

    context 'without geofence' do
      it 'is false' do
        expect(question.geofenced?).to eq(false)
      end
    end
  end

  describe '#coordinates' do
    context 'with geofence' do
      let(:latitude) { 12.345678 }
      let(:longitude) { 87.654321 }
      let!(:address_question_option) { create(:address_question_option, latitude: latitude, longitude: longitude, address_question: question) }

      it 'is an array of latitude and longitude' do
        expect(question.coordinates).to eq([latitude, longitude])
      end
    end

    context 'without geofence' do
      it 'is an empty array' do
        expect(question.coordinates).to eq([])
      end
    end
  end
end
