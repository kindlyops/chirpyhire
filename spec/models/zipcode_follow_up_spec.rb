require 'rails_helper'

RSpec.describe ZipcodeFollowUp do
  subject { create(:zipcode_follow_up) }

  describe '#tag' do
    let!(:contact) { create(:contact) }

    context 'with a tag' do
      let!(:zipcode) { create(:zipcode, :"30342") }

      before do
        subject.tags << tag
        ZipcodeFetcher.call(contact, zipcode.zipcode)
      end

      context 'without variables' do
        let!(:tag) { create(:tag, name: '1st Preferred') }

        it 'adds the tag to the contact' do
          expect {
            subject.tag(contact)
          }.to change { contact.reload.tags.count }.by(1)
        end

        it 'has the tag name' do
          subject.tag(contact)

          expect(contact.tags.last.name).to eq('1st Preferred')
        end
      end

      context 'with a zipcode liquid variable in it' do
        let!(:tag) { create(:tag, name: '1st Preferred: {{zipcode}}') }

        it 'adds the tag to the contact' do
          expect {
            subject.tag(contact)
          }.to change { contact.reload.tags.count }.by(1)
        end

        it 'creates a new tag' do
          expect {
            subject.tag(contact)
          }.to change { contact.organization.reload.tags.count }.by(1)
        end

        it 'puts the zipcode in the tag' do
          subject.tag(contact)

          expect(contact.tags.last.name).to eq("1st Preferred: #{zipcode.zipcode}")
        end
      end
    end
  end
end
