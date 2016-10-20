require 'rails_helper'
RSpec.describe GeoJson do
  let(:organization) { create(:organization, :with_subscription, :with_account) }

  context '#build_sources' do
    context 'only candidates with zipcode features' do
      let(:zipcode) { '30342' }
      let(:zipcode_candidate) { create(:candidate, zipcode: zipcode, organization: organization) }
      let(:geo_json_data) { GeoJson.build_sources([zipcode_candidate]) }
      it 'should not have any address features' do
        expect(geo_json_data[:sources][0][:features].count).to eq(0)
      end
      it 'should have zipcode features' do
        expect(geo_json_data[:sources][1][:features].count).to eq(1)
      end
      it 'feature properties should match candidate' do
        expect(geo_json_data[:sources][1][:features][0][:properties][:stage_name]).to eq(zipcode_candidate.stage.name)
        expect(geo_json_data[:sources][1][:features][0][:properties][:zipcode]).to eq(zipcode_candidate.zipcode)
      end
      context 'where the zipcode does not exist' do
        let(:zipcode) { '99999' }
        it 'should log' do
          expect {
            geo_json_data
          }.to change(Logging::Logger.logged_messages, :count).by(1)
        end
      end
    end
    context 'only candidates with address features' do
      let(:address_candidate) { create(:candidate, :with_address, organization: organization) }
      let(:geo_json_data) { GeoJson.build_sources([address_candidate]) }
      it 'should not have any zipcode features' do
        expect(geo_json_data[:sources][1][:features].count).to eq(0)
      end
      it 'should have address features' do
        expect(geo_json_data[:sources][0][:features].count).to eq(1)
      end
      it 'feature properties should match candidate' do
        expect(geo_json_data[:sources][0][:features][0][:properties][:stage_name]).to eq(address_candidate.stage.name)
      end
    end
    context 'candidates with address or zipcode features' do
      let(:address_candidate) { create(:candidate, :with_address, organization: organization) }
      let(:zipcode_candidate) { create(:candidate, zipcode: '30342', organization: organization) }
      let(:geo_json_data) { GeoJson.build_sources([address_candidate, zipcode_candidate]) }

      it 'should have address features' do
        expect(geo_json_data[:sources][0][:features].count).to eq(1)
      end
      it 'should have zipcode features' do
        expect(geo_json_data[:sources][1][:features].count).to eq(1)
      end
    end
  end
end
