# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Vcard, vcr: { cassette_name: 'Vcard' } do
  let(:media_url) { '/2010-04-01/Accounts/AC207d54ae9c08379e9e356faa6fb96f41/Messages/MMfaeed26d122c527a06e14768198c6a06/Media/MEdfa8631eb3ab5a0bf472d0e3fb5b7a76' }
  let(:url) { "https://api.twilio.com/#{media_url}" }

  let(:vcard) { Vcard.new(url: url) }

  describe '#phone_number' do
    it 'returns the phone number' do
      expect(vcard.phone_number).to eq('+14047908943')
    end
  end

  describe '#first_name' do
    it 'returns the first name' do
      expect(vcard.first_name).to eq('Harry')
    end
  end

  describe '#last_name' do
    it 'returns the last name' do
      expect(vcard.last_name).to eq('Whelchel')
    end
  end

  describe '#attributes' do
    it 'returns a hash of attributes' do
      expect(vcard.attributes.keys).to match_array([:phone_number, :first_name, :last_name])
    end
  end
end
