require 'rails_helper'

RSpec.describe 'AddressFinder' do
  let(:finder) { AddressFinder.new(address) }

  context 'with valid address', vcr: { cassette_name: 'AddressFinder-valid-address' } do
    let(:address) { '4059 Mt Lee Dr 90068' }

    describe '#found?' do
      it 'is true' do
        expect(finder.found?).to eq(true)
      end
    end

    describe '#address' do
      it do
        expect(finder.address).to eq('Mount Lee Drive, McNeil, CA 90068, United States of America')
      end
    end

    describe '#latitude' do
      it do
        expect(finder.latitude).to eq(34.1355329)
      end
    end

    describe '#longitude' do
      it do
        expect(finder.longitude).to eq(-118.317814)
      end
    end

    describe '#country' do
      it do
        expect(finder.country).to eq('United States of America')
      end
    end

    describe '#city' do
      it do
        expect(finder.city).to eq('McNeil')
      end
    end

    describe '#postal_code' do
      it do
        expect(finder.postal_code).to eq('90068')
      end
    end

    context 'multiline address', vcr: { cassette_name: 'AddressFinder-multiline' } do
      let(:address) { "3527 boulder circle\n30294" }
      describe '#found?' do
        it 'is true' do
          expect(finder.found?).to eq(true)
        end
      end
    end

    context 'with multiple results', vcr: { cassette_name: 'AddressFinder-flat-shoals' } do
      let(:address) { '3379 Flat Shoals Road Decatur Ga 30033' }
      it 'returns the result with the highest confidence' do
        expect(finder.address).not_to eq('GA 30033, United States of America')
        expect(finder.address).to eq('3379 Flat Shoals Rd, Decatur, GA, United States of America')
      end

      context 'with results in other countries', vcr: { cassette_name: 'AddressFinder-conyers' } do
        let(:address) { 'Conyers 30012' }
        it 'returns the US result with the highest confidence' do
          expect(finder.address).not_to eq('Conyers, South Norfolk District NR18, United Kingdom')
          expect(finder.address).to eq('Conyers, GA, United States of America')
        end
      end
    end
  end

  context "unfindable addresses (wrong zipcode, no zipcode, no street address)" do
    ["2 civic center drive 94913", "4059 Mt Lee Dr", "90068"].each do |address|
      let(:address) { address }
      it "is false" do
        expect(finder.found?).to eq(false)
      end
    end
  end
end
