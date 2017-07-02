require 'rails_helper'

RSpec.describe Surveyor do
  subject { Surveyor.new(contact, message) }

  describe '#start' do
    let(:organization) { create(:organization, :team, :account) }
    let(:team) { organization.teams.first }
    let(:phone_number) { organization.phone_numbers.first }
    let(:contact) { create(:contact, organization: organization, subscribed: true) }
    let(:conversation) { IceBreaker.call(contact, phone_number) }
    let!(:message) { create(:message, body: 'start', to: phone_number.phone_number, conversation: conversation, sender: contact.person) }
    let(:candidacy) { contact.contact_candidacy }

    context 'candidacy already in progress' do
      before do
        candidacy.update(state: :in_progress)
      end

      it 'does not change the candidacy contact' do
        allow(subject.survey).to receive(:ask)

        expect {
          subject.start
        }.not_to change { candidacy.reload.contact }
      end

      it 'does not change the candidacy state' do
        allow(subject.survey).to receive(:ask)

        expect {
          subject.start
        }.not_to change { candidacy.reload.state }
      end

      it 'does not ask a question in the survey' do
        expect(subject.survey).not_to receive(:ask)

        subject.start
      end

      it 'does not send a message' do
        expect(subject).not_to receive(:send_message)

        subject.start
      end

      it 'does not call ReadReceiptsCreator' do
        expect(ReadReceiptsCreator).not_to receive(:call)

        subject.start
      end
    end

    context 'candidacy not in progress' do
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

      it 'does not call ReadReceiptsCreator' do
        expect(ReadReceiptsCreator).not_to receive(:call)

        subject.start
      end
    end
  end

  describe '#consider_answer' do
    let(:organization) { create(:organization, :team, :account) }
    let(:account) { organization.accounts.first }
    let(:team) { organization.teams.first }
    let(:phone_number) { organization.phone_numbers.first }
    let(:contact) { create(:contact, organization: organization, subscribed: true) }
    let(:conversation) { IceBreaker.call(contact, phone_number) }
    let(:candidacy) { contact.contact_candidacy }
    let(:survey) { subject.survey }

    context 'in_progress' do
      before do
        team.accounts << account
        candidacy.update(state: :in_progress)
      end

      describe 'completed survey' do
        let(:message) { create(:message, body: 'a', to: phone_number.phone_number, conversation: conversation, sender: contact.person) }
        let(:inquiry) { 'skin_test' }
        before do
          candidacy.update(inquiry: inquiry)
        end

        it 'completes the survey' do
          expect(subject.survey).to receive(:complete)

          subject.consider_answer(inquiry)
        end

        it 'does not call ReadReceiptsCreator' do
          expect(ReadReceiptsCreator).not_to receive(:call)

          subject.consider_answer(inquiry)
        end

        context 'two teams same organization' do
          let!(:other_team) { create(:team, :inbox, :account, organization: team.organization) }

          before do
            IceBreaker.call(contact, phone_number)
          end

          context 'account on each team' do
            context 'contact on one team' do
              it 'sends an email to the account on the same team only' do
                expect {
                  subject.consider_answer(inquiry)
                }.to have_enqueued_job(ActionMailer::DeliveryJob)
                  .with { |mailer, mailer_method, *_args|
                       expect(mailer).to eq('NotificationMailer')
                       expect(mailer_method).to eq('contact_ready_for_review')
                     }.exactly(1).times
              end
            end
          end
        end
      end

      describe 'incomplete survey' do
        let(:inquiry) { 'experience' }
        before do
          candidacy.update(inquiry: inquiry)
        end

        describe 'valid answer' do
          let(:message) { create(:message, body: 'a', to: phone_number.phone_number, conversation: conversation, sender: contact.person) }

          it 'asks the next question' do
            expect(subject.survey).to receive(:ask)

            subject.consider_answer(inquiry)
          end

          it 'does not call ReadReceiptsCreator' do
            expect(ReadReceiptsCreator).not_to receive(:call)

            subject.consider_answer(inquiry)
          end

          context 'last question' do
            before do
              candidacy.update(inquiry: survey.last_question)
            end

            context 'and another valid answer has already come in' do
              let(:first_message) { create(:message, body: 'Y', to: phone_number.phone_number, conversation: conversation, sender: contact.person) }
              let(:second_message) { create(:message, body: 'A', to: phone_number.phone_number, conversation: conversation, sender: contact.person) }

              before do
                first_surveyor = Surveyor.new(contact, first_message)
                allow(first_surveyor.survey).to receive(:send_message)

                first_surveyor.consider_answer(survey.last_question)
              end

              it 'does not raise an error' do
                allow(subject.survey).to receive(:ask)

                expect {
                  subject.consider_answer(survey.last_question)
                }.not_to raise_error
              end

              it 'does not send a message' do
                expect(subject.survey).not_to receive(:send_message)

                subject.consider_answer(survey.last_question)
              end
            end
          end

          context 'attributes' do
            let(:message) { create(:message, body: body, to: phone_number.phone_number, conversation: conversation, sender: contact.person) }

            context 'experience' do
              let(:body) { 'a' }
              let(:inquiry) { 'experience' }

              before do
                candidacy.update(inquiry: inquiry)
              end

              it 'updates the experience' do
                allow(subject.survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry)
                }.to change { candidacy.reload.experience }.to('less_than_one')
              end

              it 'adds a 0 - 1 years tag to the contact' do
                allow(subject.survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry)
                }.to change { contact.tags.find_by(name: '0 - 1 years').present? }.from(false).to(true)
              end

              context '1 - 5 years' do
                let(:body) { 'b' }

                it 'adds a 1 - 5 years tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: '1 - 5 years').present? }.from(false).to(true)
                end
              end

              context '6+ years' do
                let(:body) { 'c' }

                it 'adds a 6+ years tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: '6+ years').present? }.from(false).to(true)
                end
              end

              context 'No Experience' do
                let(:body) { 'd' }

                it 'adds a No Experience tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'No Experience').present? }.from(false).to(true)
                end
              end

              context 'and another valid answer has already come in' do
                let(:first_message) { create(:message, body: 'A', to: phone_number.phone_number, conversation: conversation, sender: contact.person) }
                let(:second_message) { create(:message, body: 'A', to: phone_number.phone_number, conversation: conversation, sender: contact.person) }

                before do
                  first_surveyor = Surveyor.new(contact, first_message)
                  allow(first_surveyor.survey).to receive(:send_message)

                  first_surveyor.consider_answer(inquiry)
                end

                it 'does not raise an error' do
                  allow(subject.survey).to receive(:ask)

                  expect {
                    subject.consider_answer(inquiry)
                  }.not_to raise_error
                end

                it 'does not update the experience' do
                  allow(subject.survey).to receive(:ask)

                  expect {
                    subject.consider_answer(inquiry)
                  }.not_to change { candidacy.reload.experience }
                end
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
                  subject.consider_answer(inquiry)
                }.to change { candidacy.reload.availability }.to('hourly_pm')
              end

              it 'adds a PM tag to the contact' do
                allow(subject.survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry)
                }.to change { contact.tags.find_by(name: 'PM').present? }.from(false).to(true)
              end

              context 'AM' do
                let(:body) { 'a' }

                it 'adds a AM tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'AM').present? }.from(false).to(true)
                end
              end

              context 'AM/PM' do
                let(:body) { 'c' }

                it 'adds a AM/PM tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'AM/PM').present? }.from(false).to(true)
                end
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
                  subject.consider_answer(inquiry)
                }.to change { candidacy.reload.transportation }.to('no_transportation')
              end

              it 'adds a No Transportation tag to the contact' do
                allow(subject.survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry)
                }.to change { contact.tags.find_by(name: 'No Transportation').present? }.from(false).to(true)
              end

              context 'Personal Transportation' do
                let(:body) { 'a' }

                it 'adds a Personal Transportation tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'Personal Transportation').present? }.from(false).to(true)
                end
              end

              context 'Public Transportation' do
                let(:body) { 'b' }

                it 'adds a Public Transportation tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'Public Transportation').present? }.from(false).to(true)
                end
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
                  subject.consider_answer(inquiry)
                }.to change { candidacy.reload.skin_test }.to(true)
              end

              it 'adds a Skin / TB Test tag to the contact' do
                allow(subject.survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry)
                }.to change { contact.tags.find_by(name: 'Skin / TB Test').present? }.from(false).to(true)
              end

              context 'No Skin / TB Test' do
                let(:body) { 'b' }

                it 'adds a No Skin / TB Test tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'No Skin / TB Test').present? }.from(false).to(true)
                end
              end
            end

            context 'zipcode' do
              let(:body) { '30342' }
              let(:inquiry) { 'zipcode' }
              let!(:zipcode) { create(:zipcode, '30342'.to_sym) }

              before do
                candidacy.update(inquiry: inquiry)
              end

              it 'updates the value' do
                allow(subject.survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry)
                }.to change { candidacy.reload.zipcode }.to('30342')
              end

              it 'does not add a 30342 tag to the contact' do
                allow(subject.survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry)
                }.not_to change { contact.tags.count }
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
                  subject.consider_answer(inquiry)
                }.to change { candidacy.reload.certification }.to('cna')
              end

              it 'adds a CNA tag to the contact' do
                allow(subject.survey).to receive(:ask)
                expect {
                  subject.consider_answer(inquiry)
                }.to change { contact.tags.find_by(name: 'CNA').present? }.from(false).to(true)
              end

              context 'HHA' do
                let(:body) { 'b' }

                it 'adds a HHA tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'HHA').present? }.from(false).to(true)
                end
              end

              context 'PCA' do
                let(:body) { 'c' }

                it 'adds a PCA tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'PCA').present? }.from(false).to(true)
                end
              end

              context 'No Certification' do
                let(:body) { 'e' }

                it 'adds a No Certification tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'No Certification').present? }.from(false).to(true)
                end
              end

              context 'RN, LPN, Other' do
                let(:body) { 'd' }

                it 'adds a RN, LPN, Other tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'RN, LPN, Other').present? }.from(false).to(true)
                end
              end
            end

            context 'live_in' do
              let(:inquiry) { 'live_in' }
              before do
                candidacy.update(inquiry: inquiry)
              end

              context 'Live-In' do
                let(:body) { 'a' }

                it 'adds a Live-In tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'Live-In').present? }.from(false).to(true)
                end
              end

              context 'No Live-In' do
                let(:body) { 'b' }

                it 'adds a No Live-In tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'No Live-In').present? }.from(false).to(true)
                end
              end
            end

            context 'drivers_license' do
              let(:inquiry) { 'drivers_license' }
              before do
                candidacy.update(inquiry: inquiry)
              end

              context "Driver's License" do
                let(:body) { 'a' }

                it "adds a Driver's License tag to the contact" do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: "Driver's License").present? }.from(false).to(true)
                end
              end

              context "No Driver's License" do
                let(:body) { 'b' }

                it "adds a No Driver's License tag to the contact" do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: "No Driver's License").present? }.from(false).to(true)
                end
              end
            end

            context 'cpr_first_aid' do
              let(:inquiry) { 'cpr_first_aid' }
              before do
                candidacy.update(inquiry: inquiry)
              end

              context 'CPR / 1st Aid' do
                let(:body) { 'a' }

                it 'adds a CPR / 1st Aid tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'CPR / 1st Aid').present? }.from(false).to(true)
                end
              end

              context 'No CPR / 1st Aid' do
                let(:body) { 'b' }

                it 'adds a No CPR / 1st Aid tag to the contact' do
                  allow(subject.survey).to receive(:ask)
                  expect {
                    subject.consider_answer(inquiry)
                  }.to change { contact.tags.find_by(name: 'No CPR / 1st Aid').present? }.from(false).to(true)
                end
              end
            end

            context 'drivers_license' do
              let(:body) { 'b' }
              let(:inquiry) { 'drivers_license' }
              before do
                candidacy.update(inquiry: inquiry)
              end

              it 'updates the value' do
                allow(subject.survey).to receive(:complete)
                expect {
                  subject.consider_answer(inquiry)
                }.to change { candidacy.reload.drivers_license }.to(false)
              end
            end
          end
        end

        describe 'invalid answer' do
          let(:message) { create(:message, body: 'q', to: phone_number.phone_number, conversation: conversation, sender: contact.person) }
          let(:inquiry) { 'skin_test' }

          it 'restates the question' do
            expect(subject.survey).to receive(:restate)

            subject.consider_answer(inquiry)
          end

          it 'calls ReadReceiptsCreator' do
            expect(ReadReceiptsCreator).to receive(:call)

            subject.consider_answer(inquiry)
          end
        end
      end
    end
  end
end
