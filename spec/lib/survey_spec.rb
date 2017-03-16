require 'rails_helper'

RSpec.describe Survey do
  let(:candidacy) { create(:person, :with_subscribed_candidacy).candidacy }
  let(:contact) { candidacy.contact }
  subject { Survey.new(candidacy) }

  describe '#ask' do
    context 'in_progress' do
      before do
        candidacy.update(state: :in_progress)
      end

      context 'first question' do
        let(:certification) { Question::Certification.new(contact) }

        it 'sets the inquiry to certification' do
          allow(subject).to receive(:send_message).with(certification.body)
          expect {
            subject.ask
          }.to change { candidacy.reload.inquiry }.from(nil).to('certification')
        end

        it 'asks the certification question' do
          expect(subject).to receive(:send_message).with(certification.body)

          subject.ask
        end
      end

      context 'in the middle of the survey' do
        let(:transportation) { Question::Transportation.new(contact) }

        before do
          candidacy.update(inquiry: :experience)
        end

        it 'sets the inquiry to transportation' do
          allow(subject).to receive(:send_message).with(transportation.body)
          expect {
            subject.ask
          }.to change { candidacy.reload.inquiry }.from('experience').to('transportation')
        end

        it 'asks the transportation question' do
          expect(subject).to receive(:send_message).with(transportation.body)

          subject.ask
        end
      end
    end

    context 'complete' do
      before do
        candidacy.update(state: :complete)
      end

      it 'does not change the inquiry' do
        expect {
          subject.ask
        }.not_to change { candidacy.reload.inquiry }
      end

      it 'does not send a message' do
        expect(subject).not_to receive(:send_message)

        subject.ask
      end
    end
  end

  describe '#restate' do
    context 'in_progress' do
      before do
        candidacy.update(state: :in_progress)
      end

      let(:experience) { Question::Experience.new(contact) }

      before do
        candidacy.update(inquiry: :experience)
      end

      it 'sends the question restated' do
        expect(subject).to receive(:send_message).with(experience.restated)

        subject.restate
      end
    end
  end

  describe '#complete' do
    context 'in_progress' do
      before do
        candidacy.update(inquiry: Survey::LAST_QUESTION, state: :in_progress)
      end

      let(:thank_you) { Notification::ThankYou.new(contact) }

      it 'sets the candidacy inquiry to nil' do
        allow(subject).to receive(:send_message).with(thank_you.body)
        expect {
          subject.complete
        }.to change { candidacy.reload.inquiry }.from('skin_test').to(nil)
      end

      it 'sends the thank you message' do
        expect(subject).to receive(:send_message).with(thank_you.body)

        subject.complete
      end
    end
  end

  describe '#just_finished?' do
    context 'in progress' do
      before do
        candidacy.update(state: :in_progress)
      end

      context 'last_question' do
        before do
          candidacy.update(inquiry: Survey::LAST_QUESTION)
        end

        context 'invalid answer' do
          let(:message) { create(:message, body: 'e') }

          it 'is false' do
            expect(subject.just_finished?(message)).to eq(false)
          end
        end

        context 'valid answer' do
          let(:message) { create(:message, body: 'a') }

          it 'is true' do
            expect(subject.just_finished?(message)).to eq(true)
          end
        end
      end

      context 'not last question' do
        before do
          candidacy.update(inquiry: :experience)
        end

        let(:message) { create(:message, body: 'a') }

        it 'is false' do
          expect(subject.just_finished?(message)).to eq(false)
        end
      end
    end
  end
end
