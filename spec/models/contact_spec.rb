require 'rails_helper'

RSpec.describe Contact do
  subject { create(:contact, '30341'.to_sym) }

  describe '.zipcode_filter' do
    context '"DeKalb" county searched for' do
      describe 'with "Dekalb" county in database' do
        it 'is case insensitive' do
          expect(Contact.zipcode_filter(county_name: 'DeKalb')).to include(subject)
        end
      end
    end
  end
end
