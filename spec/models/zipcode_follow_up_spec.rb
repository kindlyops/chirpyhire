require 'rails_helper'

RSpec.describe ZipcodeFollowUp do
  subject { create(:zipcode_follow_up) }

  describe '#tag' do
    let!(:contact) { create(:contact) }
    let!(:message) { create(:message, body: '30342') }

    context 'with a tag' do
      before do
        subject.tags << tag
      end

      context 'without variables' do
        let!(:tag) { create(:tag, name: '1st Preferred') }

        it 'adds the tag to the contact' do
          expect {
            subject.tag(contact, message)
          }.to change { contact.reload.tags.count }.by(1)
        end

        it 'has the tag name' do
          subject.tag(contact, message)

          expect(contact.tags.last.name).to eq('1st Preferred')
        end
      end

      context 'with a message.body liquid variable in it' do
        let!(:tag) { create(:tag, name: '1st Preferred: {{message.body}}') }

        it 'adds the tag to the contact' do
          expect {
            subject.tag(contact, message)
          }.to change { contact.reload.tags.count }.by(1)
        end

        it 'creates a new tag' do
          expect {
            subject.tag(contact, message)
          }.to change { contact.organization.reload.tags.count }.by(1)
        end

        it 'puts the message.body in the tag' do
          subject.tag(contact, message)

          expect(contact.tags.last.name).to eq("1st Preferred: #{message.body}")
        end
      end
    end
  end
end
