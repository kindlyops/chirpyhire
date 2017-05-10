require 'rails_helper'

RSpec.describe BrokerSurveyor do
  subject { BrokerSurveyor.new(broker_contact) }

  describe '#start' do
    let(:broker_contact) { create(:broker_contact) }
    let(:broker) { broker_contact.broker }
    let(:broker_candidacy) { broker_contact.person.broker_candidacy }

    context 'broker_candidacy already in progress' do
      before do
        broker_candidacy.update(broker_contact: broker_contact, state: :in_progress)
      end

      it 'does not change the broker_candidacy broker_contact' do
        allow(subject.broker_survey).to receive(:ask)

        expect {
          subject.start
        }.not_to change { broker_candidacy.reload.broker_contact }
      end

      it 'does not change the broker_candidacy state' do
        allow(subject.broker_survey).to receive(:ask)

        expect {
          subject.start
        }.not_to change { broker_candidacy.reload.state }
      end

      it 'does not ask a question in the survey' do
        expect(subject.broker_survey).not_to receive(:ask)

        subject.start
      end

      it 'does not send a message' do
        expect(subject).not_to receive(:send_message)

        subject.start
      end
    end

    context 'broker_candidacy completed' do
      before do
        broker_candidacy.update(broker_contact: broker_contact, state: :complete)
      end

      it 'does not change the broker_candidacy broker_contact' do
        allow(subject.broker_survey).to receive(:ask)

        expect {
          subject.start
        }.not_to change { broker_candidacy.reload.broker_contact }
      end

      it 'does not change the broker_candidacy state' do
        allow(subject.broker_survey).to receive(:ask)

        expect {
          subject.start
        }.not_to change { broker_candidacy.reload.state }
      end

      it 'does not ask a question in the survey' do
        expect(subject.broker_survey).not_to receive(:ask)

        subject.start
      end

      it 'does not send a message' do
        expect(subject).not_to receive(:send_message)

        subject.start
      end
    end

    context 'broker_candidacy not in progress' do
      it 'locks the broker_candidacy to the broker_contact' do
        allow(subject.broker_survey).to receive(:ask)

        expect {
          subject.start
        }.to change { broker_candidacy.reload.broker_contact }.from(nil).to(broker_contact)
      end

      it 'sets the broker_candidacy to in progress' do
        allow(subject.broker_survey).to receive(:ask)

        expect {
          subject.start
        }.to change { broker_candidacy.reload.state }.from('pending').to('in_progress')
      end

      it 'asks the next question in the survey' do
        expect(subject.broker_survey).to receive(:ask)

        subject.start
      end
    end
  end

  describe '#consider_answer' do
    let(:broker_candidacy) { create(:person, :with_broker_subscribed_candidacy).broker_candidacy }
    let(:broker_contact) { broker_candidacy.broker_contact }
    let(:broker) { broker_contact.broker }

    context 'in_progress' do
      before do
        broker_candidacy.update(state: :in_progress)
      end

      describe 'completed survey' do
        let(:message) { create(:message, body: 'a') }
        let(:inquiry) { 'skin_test' }
        before do
          broker_candidacy.update(inquiry: inquiry)
        end

        it 'completes the survey' do
          expect(subject.broker_survey).to receive(:complete)

          subject.consider_answer(inquiry, message)
        end
      end

      describe 'incomplete survey' do
        let(:inquiry) { 'experience' }
        before do
          broker_candidacy.update(inquiry: inquiry)
        end

        describe 'valid answer' do
          let(:message) { create(:message, body: 'a') }

          it 'asks the next question' do
            expect(subject.broker_survey).to receive(:ask)

            subject.consider_answer(inquiry, message)
          end

          context 'last question' do
            before do
              broker_candidacy.update(inquiry: BrokerSurvey::LAST_QUESTION)
            end

            context 'and another valid answer has already come in' do
              let(:first_message) { create(:message, body: 'Y') }
              let(:second_message) { create(:message, body: 'A') }

              before do
                first_surveyor = BrokerSurveyor.new(broker_contact)
                allow(first_surveyor.broker_survey).to receive(:send_message)

                first_surveyor.consider_answer(BrokerSurvey::LAST_QUESTION, first_message)
              end

              it 'does not raise an error' do
                allow(subject.broker_survey).to receive(:ask)

                expect {
                  subject.consider_answer(BrokerSurvey::LAST_QUESTION, second_message)
                }.not_to raise_error
              end

              it 'does not send a message' do
                expect(subject.broker_survey).not_to receive(:send_message)

                subject.consider_answer(BrokerSurvey::LAST_QUESTION, second_message)
              end
            end
          end

          context 'attributes' do
            let(:message) { create(:message, body: body) }

            context 'experience' do
              let(:body) { 'a' }
              let(:inquiry) { 'experience' }

              before do
                broker_candidacy.update(inquiry: inquiry)
              end

              it 'updates the experience' do
                allow(subject.broker_survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry, message)
                }.to change { broker_candidacy.reload.experience }.to('less_than_one')
              end

              context 'and another valid answer has already come in' do
                let(:first_message) { create(:message, body: 'A') }
                let(:second_message) { create(:message, body: 'A') }

                before do
                  first_surveyor = BrokerSurveyor.new(broker_contact)
                  allow(first_surveyor.broker_survey).to receive(:send_message)

                  first_surveyor.consider_answer(inquiry, first_message)
                end

                it 'does not raise an error' do
                  allow(subject.broker_survey).to receive(:ask)

                  expect {
                    subject.consider_answer(inquiry, second_message)
                  }.not_to raise_error
                end

                it 'does not update the experience' do
                  allow(subject.broker_survey).to receive(:ask)

                  expect {
                    subject.consider_answer(inquiry, message)
                  }.not_to change { broker_candidacy.reload.experience }
                end
              end
            end

            context 'availability' do
              let(:body) { 'b' }
              let(:inquiry) { 'availability' }

              before do
                broker_candidacy.update(inquiry: inquiry)
              end

              it 'updates the value' do
                allow(subject.broker_survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry, message)
                }.to change { broker_candidacy.reload.availability }.to('hourly_pm')
              end
            end

            context 'transportation' do
              let(:body) { 'c' }
              let(:inquiry) { 'transportation' }
              before do
                broker_candidacy.update(inquiry: inquiry)
              end

              it 'updates the value' do
                allow(subject.broker_survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry, message)
                }.to change { broker_candidacy.reload.transportation }.to('no_transportation')
              end
            end

            context 'skin_test' do
              let(:body) { 'a' }
              let(:inquiry) { 'skin_test' }
              before do
                broker_candidacy.update(inquiry: inquiry)
              end

              it 'updates the value' do
                allow(subject.broker_survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry, message)
                }.to change { broker_candidacy.reload.skin_test }.to(true)
              end
            end

            context 'zipcode' do
              let(:body) { '30342' }
              let(:inquiry) { 'zipcode' }

              before do
                broker_candidacy.update(inquiry: inquiry)
              end

              it 'updates the value' do
                allow(subject.broker_survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry, message)
                }.to change { broker_candidacy.reload.zipcode }.to('30342')
              end
            end

            context 'certification' do
              let(:body) { 'a' }
              let(:inquiry) { 'certification' }
              before do
                broker_candidacy.update(inquiry: inquiry)
              end

              it 'updates the value' do
                allow(subject.broker_survey).to receive(:complete)
                expect {
                  subject.consider_answer(inquiry, message)
                }.to change { broker_candidacy.reload.certification }.to('cna')
              end
            end
          end
        end

        describe 'invalid answer' do
          let(:message) { create(:message, body: 'q') }
          let(:inquiry) { 'skin_test' }

          it 'restates the question' do
            expect(subject.broker_survey).to receive(:restate)

            subject.consider_answer(inquiry, message)
          end
        end
      end
    end
  end
end
