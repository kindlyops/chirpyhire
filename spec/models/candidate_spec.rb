require 'rails_helper'

RSpec.describe Candidate, type: :model do
  let(:candidate) { create(:candidate) }

  describe '#activity tracking' do
    describe 'create' do
      it 'creates an activity' do
        expect {
          candidate
        }.to change { PublicActivity::Activity.count }.by(1)
        expect(candidate.activities.last.properties['status']).to eq('Potential')
      end
    end

    describe 'update' do
      let!(:candidate) { create(:candidate) }

      context 'changing the status' do
        it 'creates an activity' do
          expect {
            candidate.update(status: 'Qualified')
          }.to change { PublicActivity::Activity.count }.by(1)
          expect(candidate.activities.last.properties['status']).to eq('Qualified')
        end
      end

      context 'not changing the status' do
        it 'does not create an activity' do
          expect {
            candidate.touch
          }.not_to change { PublicActivity::Activity.count }
        end
      end
    end

    describe 'destroy' do
      let!(:candidate) { create(:candidate) }

      it 'does not create an activity' do
        expect {
          candidate.destroy
        }.not_to change { PublicActivity::Activity.count }
      end
    end
  end

  describe '#address' do
    context 'with an address candidate feature' do
      let(:latitude) { '12.123456' }
      let(:longitude) { '34.156788' }
      let(:address_properties) do
        {
          address: '123 Main St. 30309',
          latitude: latitude,
          longitude: longitude,
          child_class: 'address'
        }
      end

      before do
        create(:candidate_feature, candidate: candidate, properties: address_properties)
      end

      it 'has a latitude' do
        expect(candidate.address.latitude).to eq(latitude)
      end

      it 'has a longitude' do
        expect(candidate.address.longitude).to eq(longitude)
      end
    end

    context 'without an address candidate feature' do
      it 'does not have a latitude' do
        expect(candidate.address.latitude).to eq(nil)
      end

      it 'does not have a longitude' do
        expect(candidate.address.latitude).to eq(nil)
      end
    end
  end
end
