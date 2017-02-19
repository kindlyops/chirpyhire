require 'rails_helper'

RSpec.describe Surveyor do
  subject { Surveyor.new(subscriber) }

  describe '#start' do
    let(:subscriber) { create(:subscriber) }
    let(:thank_you) { Notification::ThankYou.new(subscriber) }
    let(:candidacy) { subscriber.person.candidacy }

    context 'candidacy has a subscriber already' do
      before do
        candidacy.update(subscriber: subscriber)
      end

      it 'sends the thank you message' do
        expect(subject).to receive(:send_message).with(thank_you.body)

        subject.start
      end
    end

    context 'candidacy does not have a subscriber' do
      it 'locks the candidacy to the subscriber' do
        allow(subject.survey).to receive(:ask)

        expect {
          subject.start
        }.to change { candidacy.reload.surveying? }.from(false).to(true)
      end

      it 'asks the next question in the survey' do
        expect(subject.survey).to receive(:ask)

        subject.start
      end
    end
  end

  describe '#consider_answer' do
    let(:candidacy) { create(:person, :with_subscribed_candidacy).candidacy }
    let(:subscriber) { candidacy.subscriber }

    describe 'completed survey' do
      let(:message) { create(:message, body: 'a') }
      before do
        candidacy.update(inquiry: :certification)
      end

      it 'completes the survey' do
        expect(subject.survey).to receive(:complete)

        subject.consider_answer(message)
      end
    end

    describe 'incomplete survey' do
      before do
        candidacy.update(inquiry: :experience)
      end

      describe 'valid answer' do
        let(:message) { create(:message, body: 'a') }

        it 'asks the next question' do
          expect(subject.survey).to receive(:ask)

          subject.consider_answer(message)
        end

        context 'attributes' do
          let(:message) { create(:message, body: body) }

          context 'experience' do
            let(:body) { 'a' }
            before do
              candidacy.update(inquiry: 'experience')
            end

            it 'updates the experience' do
              allow(subject.survey).to receive(:ask)
              expect {
                subject.consider_answer(message)
              }.to change { candidacy.reload.experience }.to('less_than_one')
            end
          end

          context 'availability' do
            let(:body) { 'b' }
            before do
              candidacy.update(inquiry: 'availability')
            end

            it 'updates the value' do
              allow(subject.survey).to receive(:ask)
              expect {
                subject.consider_answer(message)
              }.to change { candidacy.reload.availability }.to('full_time')
            end
          end

          context 'transportation' do
            let(:body) { 'c' }
            before do
              candidacy.update(inquiry: 'transportation')
            end

            it 'updates the value' do
              allow(subject.survey).to receive(:ask)
              expect {
                subject.consider_answer(message)
              }.to change { candidacy.reload.transportation }.to('no_transportation')
            end
          end

          context 'skin_test' do
            let(:body) { 'a' }
            before do
              candidacy.update(inquiry: 'skin_test')
            end

            it 'updates the value' do
              allow(subject.survey).to receive(:ask)
              expect {
                subject.consider_answer(message)
              }.to change { candidacy.reload.skin_test }.to(true)
            end
          end

          context 'zipcode' do
            let(:body) { '30342' }
            before do
              candidacy.update(inquiry: 'zipcode')
            end

            it 'updates the value' do
              allow(subject.survey).to receive(:ask)
              expect {
                subject.consider_answer(message)
              }.to change { candidacy.reload.zipcode }.to('30342')
            end
          end

          context 'certification' do
            let(:body) { 'a' }
            before do
              candidacy.update(inquiry: 'certification')
            end

            it 'updates the value' do
              allow(subject.survey).to receive(:complete)
              expect {
                subject.consider_answer(message)
              }.to change { candidacy.reload.certification }.to('pca')
            end
          end
        end
      end

      describe 'invalid answer' do
        let(:message) { create(:message, body: 'q') }

        it 'restates the question' do
          expect(subject.survey).to receive(:restate)

          subject.consider_answer(message)
        end
      end
    end
  end
end
