require 'rails_helper'

RSpec.describe 'Caregivers' do
  let(:account) { create(:account) }

  before do
    create(:broker)
    sign_in(account)
  end

  context 'with caregivers' do
    let!(:pca) { create(:contact, :pca, organization: account.organization) }
    let!(:cna) { create(:contact, :cna, organization: account.organization) }

    context 'filter PCA only' do
      let(:params) do
        {
          certification: ['pca']
        }
      end

      context 'without zipcode filter' do
        it 'returns only PCA caregivers' do
          get caregivers_path, params: params

          expect(response.body).not_to include(cna.handle)
          expect(response.body).to include(pca.handle)
        end
      end
    end

    context 'sort order' do
      it 'returns the newest records first' do
        get caregivers_path

        expect(response.body).to have_ordered(cna.handle, pca.handle)
      end
    end
  end
end
