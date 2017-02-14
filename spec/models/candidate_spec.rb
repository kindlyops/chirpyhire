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
            candidate.update(nickname: 'Foo')
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

  describe 'zipcode' do
    context 'with a zipcode feature' do
      let(:zipcode_properties) do
        {
          option: '30342',
          child_class: 'zipcode'
        }
      end
      let(:candidate_feature) { create(:candidate_feature, candidate: candidate, properties: zipcode_properties) }

      it 'works' do
        candidate_feature
        expect(candidate.zipcode).to eq(zipcode_properties[:option])
      end

      context 'with a zipcode+4' do
        let(:zipcode_properties) do
          {
            option: '30342-2039',
            child_class: 'zipcode'
          }
        end
        it 'cuts it down to just five digits' do
          candidate_feature
          expect(candidate.zipcode).to eq('30342')
        end
      end

      context 'with a shortened zipcode from address' do
        let(:zipcode_properties) do
          {
            option: 'NR18',
            child_class: 'zipcode'
          }
        end
        it 'is the same' do
          candidate_feature
          expect(candidate.zipcode).to eq('NR18')
        end
      end
    end
    context 'without a zipcode feature' do
      context 'with an address feature' do
        let(:latitude) { '12.123456' }
        let(:longitude) { '34.156788' }
        let(:address_properties) do
          {
            address: '123 Main St. 30309',
            latitude: latitude,
            longitude: longitude,
            postal_code: '30327',
            child_class: 'address'
          }
        end
        let(:address_feature) { create(:candidate_feature, candidate: candidate, properties: address_properties) }
        it 'works' do
          address_feature
          expect(candidate.zipcode).to eq(address_properties[:postal_code])
        end
      end
      context 'without an address feature' do
        it 'is nil' do
          expect(candidate.zipcode).to eq(nil)
        end
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
