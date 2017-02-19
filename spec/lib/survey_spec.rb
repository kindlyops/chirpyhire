require 'rails_helper'

RSpec.describe Survey do

  let(:candidacy) { create(:candidacy, :with_subscriber) }
  let(:subscriber) { candidacy.subscriber }
  subject { Survey.new(candidacy) }

  describe '#ask' do
    context 'first question' do
      let(:experience) { Question::Experience.new(subscriber) }

      it 'sets the inquiry to experience' do
        allow(subject).to receive(:send_message).with(experience.body)
        expect {
          subject.ask
        }.to change { candidacy.reload.inquiry }.from(nil).to('experience')
      end

      it 'asks the experience question' do
        expect(subject).to receive(:send_message).with(experience.body)

        subject.ask
      end
    end

    context 'in the middle of the survey' do
      let(:skin_test) { Question::SkinTest.new(subscriber) }

      before do
        candidacy.update(inquiry: :experience)
      end

      it 'sets the inquiry to skin_test' do
        allow(subject).to receive(:send_message).with(skin_test.body)
        expect {
          subject.ask
        }.to change { candidacy.reload.inquiry }.from('experience').to('skin_test')
      end

      it 'asks the skin_test question' do
        expect(subject).to receive(:send_message).with(skin_test.body)

        subject.ask
      end
    end

    context 'last question' do
      before do
        candidacy.update(inquiry: :certification)
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
    let(:experience) { Question::Experience.new(subscriber) }

    before do
      candidacy.update(inquiry: :experience)
    end

    it 'sends the question restated' do
      expect(subject).to receive(:send_message).with(experience.restated)

      subject.restate
    end
  end

  describe '#complete' do
    before do
      candidacy.update(inquiry: :certification)
    end

    let(:thank_you) { Notification::ThankYou.new(subscriber) }

    it 'sets the candidacy inquiry to nil' do
      allow(subject).to receive(:send_message).with(thank_you.body)
      expect {
        subject.complete
      }.to change { candidacy.reload.inquiry }.from('certification').to(nil)
    end

    it 'sends the thank you message' do
      expect(subject).to receive(:send_message).with(thank_you.body)

      subject.complete
    end
  end

  describe '#complete?' do
    context 'last question' do
      before do
        candidacy.update(inquiry: :certification)
      end

      context 'invalid answer' do
        let(:message) { create(:message, body: 'e') }

        it 'is false' do
          expect(subject.complete?(message)).to eq(false)
        end
      end

      context 'valid answer' do
        let(:message) { create(:message, body: 'a') }

        it 'is true' do
          expect(subject.complete?(message)).to eq(true)
        end
      end
    end

    context 'not last question' do
      before do
        candidacy.update(inquiry: :experience)
      end

      let(:message) { create(:message, body: 'a') }

      it 'is false' do
        expect(subject.complete?(message)).to eq(false)
      end
    end
  end
end
