require 'rails_helper'
RSpec.describe GeoJson do
  let(:organization) { create(:organization, :with_subscription, :with_account) }

  context '#build_geojson_data' do
    context 'where the zipcode exists' do
      context 'only candidates with zipcode features' do
        let(:zipcode) { '30342' }
        let(:zipcode_candidate) { create(:candidate, zipcode: zipcode, organization: organization) }
        let(:geo_json_data) { GeoJson.build_geojson_data([zipcode_candidate]) }
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
      end
      context 'only candidates with address features' do
        let(:address_candidate) { create(:candidate, :with_address, address_zipcode: '30342', organization: organization) }
        let(:geo_json_data) { GeoJson.build_geojson_data([address_candidate]) }
        it 'should have zipcode features' do
          expect(geo_json_data[:sources][1][:features].count).to eq(1)
        end
        it 'should have address features' do
          expect(geo_json_data[:sources][0][:features].count).to eq(1)
        end
        it 'feature properties should match candidate' do
          expect(geo_json_data[:sources][0][:features][0][:properties][:stage_name]).to eq(address_candidate.stage.name)
        end
      end
      context 'candidates with address or zipcode features' do
        let(:address_candidate) { create(:candidate, :with_address, address_zipcode: '30305', organization: organization) }
        let(:zipcode_candidate) { create(:candidate, zipcode: '30342', organization: organization) }
        let(:geo_json_data) { GeoJson.build_geojson_data([address_candidate, zipcode_candidate]) }

        it 'should have address features' do
          expect(geo_json_data[:sources][0][:features].count).to eq(1)
        end
        it 'should have zipcode features' do
          expect(geo_json_data[:sources][1][:features].count).to eq(2)
        end
      end
    end
  end
end
