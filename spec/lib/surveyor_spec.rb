require 'rails_helper'

RSpec.describe Surveyor do
  subject { Surveyor.new(contact) }

  describe '#start' do
    let(:contact) { create(:contact) }
    let(:thank_you) { Notification::ThankYou.new(contact) }
    let(:candidacy) { contact.person.candidacy }

    context 'candidacy already in progress' do
      before do
        candidacy.update(contact: contact, state: :in_progress)
      end

      it 'sends the thank you message' do
        expect(subject).to receive(:send_message).with(thank_you.body)

        subject.start
      end
    end

    context 'candidacy does not have a contact' do
      it 'locks the candidacy to the contact' do
        allow(subject.survey).to receive(:ask)

        expect {
          subject.start
        }.to change { candidacy.reload.contact }.from(nil).to(contact)
      end

      it 'sets the candidacy to in progress' do
        allow(subject.survey).to receive(:ask)

        expect {
          subject.start
        }.to change { candidacy.reload.state }.from('pending').to('in_progress')
      end

      it 'asks the next question in the survey' do
        expect(subject.survey).to receive(:ask)

        subject.start
      end
    end
  end

  describe '#consider_answer' do
    let(:candidacy) { create(:person, :with_subscribed_candidacy).candidacy }
    let(:contact) { candidacy.contact }

    describe 'completed survey' do
      let(:message) { create(:message, body: 'a') }
      let(:inquiry) { 'skin_test' }
      before do
        candidacy.update(inquiry: inquiry)
      end

      it 'completes the survey' do
        expect(subject.survey).to receive(:complete)

        subject.consider_answer(inquiry, message)
      end
    end

    describe 'incomplete survey' do
      let(:inquiry) { 'experience' }
      before do
        candidacy.update(inquiry: inquiry)
      end

      describe 'valid answer' do
        let(:message) { create(:message, body: 'a') }

        it 'asks the next question' do
          expect(subject.survey).to receive(:ask)

          subject.consider_answer(inquiry, message)
        end

        context 'last question' do
          before do
            candidacy.update(inquiry: Survey::LAST_QUESTION)
          end

          context 'and another valid answer has already come in' do
            let(:first_message) { create(:message, body: 'Y') }
            let(:second_message) { create(:message, body: 'A') }

            before do
              first_surveyor = Surveyor.new(contact)
              allow(first_surveyor.survey).to receive(:send_message)

              first_surveyor.consider_answer(Survey::LAST_QUESTION, first_message)
            end

            it 'does not raise an error' do
              allow(subject.survey).to receive(:ask)

              expect {
                subject.consider_answer(Survey::LAST_QUESTION, second_message)
              }.not_to raise_error
            end
          end
        end

        context 'attributes' do
          let(:message) { create(:message, body: body) }

          context 'experience' do
            let(:body) { 'a' }
            let(:inquiry) { 'experience' }

            before do
              candidacy.update(inquiry: inquiry)
            end

            it 'updates the experience' do
              allow(subject.survey).to receive(:ask)
              expect {
                subject.consider_answer(inquiry, message)
              }.to change { candidacy.reload.experience }.to('less_than_one')
            end
          end

          context 'availability' do
            let(:body) { 'b' }
            let(:inquiry) { 'availability' }

            before do
              candidacy.update(inquiry: inquiry)
            end

            it 'updates the value' do
              allow(subject.survey).to receive(:ask)
              expect {
                subject.consider_answer(inquiry, message)
              }.to change { candidacy.reload.availability }.to('hourly')
            end
          end

          context 'transportation' do
            let(:body) { 'c' }
            let(:inquiry) { 'transportation' }
            before do
              candidacy.update(inquiry: inquiry)
            end

            it 'updates the value' do
              allow(subject.survey).to receive(:ask)
              expect {
                subject.consider_answer(inquiry, message)
              }.to change { candidacy.reload.transportation }.to('no_transportation')
            end
          end

          context 'skin_test' do
            let(:body) { 'a' }
            let(:inquiry) { 'skin_test' }
            before do
              candidacy.update(inquiry: inquiry)
            end

            it 'updates the value' do
              allow(subject.survey).to receive(:ask)
              expect {
                subject.consider_answer(inquiry, message)
              }.to change { candidacy.reload.skin_test }.to(true)
            end
          end

          context 'zipcode' do
            let(:body) { '30342' }
            let(:inquiry) { 'zipcode' }

            before do
              candidacy.update(inquiry: inquiry)
            end

            it 'updates the value' do
              allow(subject.survey).to receive(:ask)
              expect {
                subject.consider_answer(inquiry, message)
              }.to change { candidacy.reload.zipcode }.to('30342')
            end
          end

          context 'certification' do
            let(:body) { 'a' }
            let(:inquiry) { 'certification' }
            before do
              candidacy.update(inquiry: inquiry)
            end

            it 'updates the value' do
              allow(subject.survey).to receive(:complete)
              expect {
                subject.consider_answer(inquiry, message)
              }.to change { candidacy.reload.certification }.to('pca')
            end
          end
        end
      end

      describe 'invalid answer' do
        let(:message) { create(:message, body: 'q') }
        let(:inquiry) { 'skin_test' }

        it 'restates the question' do
          expect(subject.survey).to receive(:restate)

          subject.consider_answer(inquiry, message)
        end
      end
    end
  end
end
