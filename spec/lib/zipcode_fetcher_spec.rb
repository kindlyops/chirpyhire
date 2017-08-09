require 'rails_helper'

RSpec.describe ZipcodeFetcher do
  let(:contact) { create(:contact) }

  describe '#call' do
    context 'with an existing zipcode' do
      let(:zipcode) { create(:zipcode, '30342'.to_sym) }
      subject { ZipcodeFetcher.new(contact, zipcode.zipcode) }

      it 'sets the contact zipcode as existing zipcode' do
        expect {
          subject.call
        }.to change { contact.reload.zipcode }.from(nil).to(zipcode)
      end
    end

    context 'when the zipcode does not exist', vcr: { cassette_name: 'ZipcodeFetcher' } do
      subject { ZipcodeFetcher.new(contact, '30342') }

      it 'creates a new zipcode' do
        expect {
          subject.call
        }.to change { Zipcode.count }.by(1)
      end

      it 'sets the contact zipcode' do
        expect {
          subject.call
        }.to change { contact.reload.zipcode }.from(nil)
      end
    end
  end
end
