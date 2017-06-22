require 'rails_helper'

RSpec.describe Survey do
  let(:contact) { create(:contact) }
  let(:candidacy) { contact.contact_candidacy }
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
        candidacy.update(inquiry: subject.last_question, state: :in_progress)
      end

      let(:thank_you) { Notification::ThankYou.new(contact) }

      it 'sets the candidacy inquiry to nil' do
        allow(subject).to receive(:send_message).with(thank_you.body)
        expect {
          subject.complete
        }.to change { candidacy.reload.inquiry }.from('skin_test').to(nil)
      end

      it 'marks the contact as screened' do
        allow(subject).to receive(:send_message).with(thank_you.body)

        expect {
          subject.complete
        }.to change { contact.reload.screened? }.from(false).to(true)
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
          candidacy.update(inquiry: subject.last_question)
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

  describe '#next_question' do
    let(:organization) { contact.organization }
    context 'pristine contact_candidacy' do
      it 'is Question::Certification' do
        expect(subject.next_question).to be_a(Question::Certification)
      end

      context 'with certification disabled' do
        before do
          organization.update(certification: false)
        end

        it 'is Question::Availability' do
          expect(subject.next_question).to be_a(Question::Availability)
        end

        context 'with availability disabled' do
          before do
            organization.update(availability: false)
          end

          it 'is Question::LiveIn' do
            expect(subject.next_question).to be_a(Question::LiveIn)
          end

          context 'with live_in disabled' do
            before do
              organization.update(live_in: false)
            end

            it 'is Question::Experience' do
              expect(subject.next_question).to be_a(Question::Experience)
            end

            context 'with experience disabled' do
              before do
                organization.update(experience: false)
              end

              it 'is Question::Transportation' do
                expect(subject.next_question).to be_a(Question::Transportation)
              end

              context 'with transportation disabled' do
                before do
                  organization.update(transportation: false)
                end

                it 'is Question::Zipcode' do
                  expect(subject.next_question).to be_a(Question::Zipcode)
                end

                context 'with zipcode disabled' do
                  before do
                    organization.update(zipcode: false)
                  end

                  it 'is Question::CprFirstAid' do
                    expect(subject.next_question).to be_a(Question::CprFirstAid)
                  end

                  context 'with cpr_first_aid disabled' do
                    before do
                      organization.update(cpr_first_aid: false)
                    end

                    it 'is Question::SkinTest' do
                      expect(subject.next_question).to be_a(Question::SkinTest)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  describe '#last_question?' do
    let(:organization) { contact.organization }
    context 'asked one question contact_candidacy' do
      before do
        candidacy.update(inquiry: :certification)
      end

      it 'is false' do
        expect(subject.last_question?).to eq(false)
      end

      context 'with all questions after disabled' do
        before do
          organization.update(
            certification: true,
            availability: false,
            live_in: false,
            experience: false,
            transportation: false,
            zipcode: false,
            cpr_first_aid: false,
            skin_test: false
          )
        end

        it 'is true' do
          expect(subject.last_question?).to eq(true)
        end
      end

      context 'with all questions disabled' do
        before do
          organization.update(
            certification: false,
            availability: false,
            live_in: false,
            experience: false,
            transportation: false,
            zipcode: false,
            cpr_first_aid: false,
            skin_test: false
          )
        end

        it 'is true' do
          expect(subject.last_question?).to eq(true)
        end
      end
    end
  end
end
