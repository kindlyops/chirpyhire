require 'rails_helper'
RSpec.describe Candidate, type: :model do
  let(:candidate) { create(:candidate) }

  describe '#activity tracking' do
    describe 'create' do
      it 'creates an activity' do
        expect {
          candidate
        }.to change { PublicActivity::Activity.count }.by(1)
        expect(candidate.activities.last.properties['stage_id']).to eq(candidate.organization.potential_stage.id)
      end
    end

    describe 'update' do
      let!(:candidate) { create(:candidate) }

      context 'changing the stage' do
        it 'creates an activity' do
          expect {
            candidate.update(stage: candidate.organization.qualified_stage)
          }.to change { PublicActivity::Activity.count }.by(1)
          expect(candidate.activities.last.properties['stage_id']).to eq(candidate.organization.qualified_stage.id)
        end

        it 'creates an activity with the organization as owner' do
          candidate.update(stage: candidate.organization.qualified_stage)
          expect(candidate.activities.last.owner).to eq(candidate.organization)
        end
      end

      context 'not changing the stage' do
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

      before(:each) do
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
      it 'does not have an address' do
        expect(candidate.address).to eq(nil)
      end
    end
  end

  context '#before_create' do
    it 'has a stage' do
      expect(candidate.stage).not_to eq(nil)
    end
    it 'has a nickname' do
      expect(candidate.nickname).not_to eq(nil)
    end
  end
end
