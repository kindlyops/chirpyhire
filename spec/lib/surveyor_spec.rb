require 'rails_helper'

RSpec.describe Surveyor do
  let(:subscriber) { create(:subscriber) }
  let(:thank_you) { Notification::ThankYou.new(subscriber) }
  let(:candidacy) { subscriber.person.candidacy }

  subject { Surveyor.new(subscriber) }

  describe '#start' do
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
end
