require 'rails_helper'

RSpec.describe 'AWS' do
  let(:finder) { AddressFinder.new(address) }

  describe '.object' do
    context 'success', vcr: { cassette_name: 'AWS-object-success' } do
      it 'works' do
        data = S3_BUCKET.object("geo_json_data/state_to_zipcode_mapping.json").get
        expect(data.present?).to be(true)
      end
    end
    context 'failure', vcr: { cassette_name: 'AWS-object-failure' } do
      it 'does not get non existent files' do
        expect {
          S3_BUCKET.object("geo_json_data/i_do_not_exist.json").get
        }.to raise_error(Aws::S3::Errors::AccessDenied)
      end
    end
  end
end
