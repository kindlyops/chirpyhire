require 'rails_helper'

RSpec.describe Surveyor do
  subject { Surveyor.new(contact) }

  describe '#start' do
    let(:team) { create(:team, :account) }
    let(:contact) { create(:contact, team: team, subscribed: true) }
    let(:candidacy) { contact.person.candidacy }

    before do
      IceBreaker.call(contact)
    end

    context 'candidacy already in progress' do
      before do
        candidacy.update(contact: contact, state: :in_progress)
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

    context 'candidacy completed' do
      before do
        candidacy.update(contact: contact, state: :complete)
      end

      context 'but account is no longer on the same team as the contact' do
        before do
          team.accounts.destroy(team.accounts.first)
        end

        it 'does not send an email to the account' do
          expect {
            subject.start
          }.not_to have_enqueued_job(ActionMailer::DeliveryJob)
        end
      end

      context 'subscribed to multiple teams' do
        let(:other_team) { create(:team, :account) }

        before do
          other_contact = other_team.contacts.create(person: contact.person)
          IceBreaker.call(other_contact)
        end

        context 'multiple teams' do
          context 'current team having multiple accounts' do
            before do
              account = create(:account, organization: team.organization)
              team.accounts << account
              GlacierBreaker.call(account)
            end

            it 'sends an email to each account on the current team' do
              expect {
                subject.start
              }.to have_enqueued_job(ActionMailer::DeliveryJob)
                .with { |mailer, mailer_method, *_args|
                     expect(mailer).to eq('NotificationMailer')
                     expect(mailer_method).to eq('contact_ready_for_review')
                   }.exactly(2).times
            end

            context 'with 10 contacts with conversations' do
              before do
                contacts = create_list(:contact, 10, team: team)
                contacts.each do |contact|
                  IceBreaker.call(contact)
                end
              end

              it 'sends an email to each account on the current team' do
                expect {
                  subject.start
                }.to have_enqueued_job(ActionMailer::DeliveryJob)
                  .with { |mailer, mailer_method, *_args|
                       expect(mailer).to eq('NotificationMailer')
                       expect(mailer_method).to eq('contact_ready_for_review')
                     }.exactly(2).times
              end
            end
          end

          context 'other team having multiple accounts' do
            before do
              account = create(:account, organization: other_team.organization)
              other_team.accounts << account
              GlacierBreaker.call(account)
            end

            it 'does not send an email to the other accounts' do
              expect {
                subject.start
              }.to have_enqueued_job(ActionMailer::DeliveryJob)
                .with { |mailer, mailer_method, *_args|
                     expect(mailer).to eq('NotificationMailer')
                     expect(mailer_method).to eq('contact_ready_for_review')
                   }.exactly(1).times
            end
          end
        end
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

      it 'does not call ReadReceiptsCreator' do
        expect(ReadReceiptsCreator).not_to receive(:call)

        subject.start
      end
    end
  end

  describe '#consider_answer' do
    let(:candidacy) { create(:person, :with_subscribed_candidacy).candidacy }
    let(:contact) { candidacy.contact }
    let(:team) { contact.team }

    before do
      contact.update(subscribed: true)
      account = create(:account, organization: team.organization)
      team.accounts << account
      IceBreaker.call(contact)
    end

    context 'in_progress' do
      before do
        candidacy.update(state: :in_progress)
      end

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

        it 'does not call ReadReceiptsCreator' do
          expect(ReadReceiptsCreator).not_to receive(:call)

          subject.consider_answer(inquiry, message)
        end

        context 'two teams same organization' do
          let!(:other_team) { create(:team, :account, organization: team.organization) }

          before do
            IceBreaker.call(contact)
          end

          context 'account on each team' do
            context 'contact on one team' do
              it 'sends an email to the account on the same team only' do
                expect {
                  subject.consider_answer(inquiry, message)
                }.to have_enqueued_job(ActionMailer::DeliveryJob)
                  .with { |mailer, mailer_method, *_args|
                       expect(mailer).to eq('NotificationMailer')
                       expect(mailer_method).to eq('contact_ready_for_review')
                     }.exactly(1).times
              end
            end
          end
        end

        context 'subscribed to multiple teams' do
          let(:other_team) { create(:team, :account) }

          before do
            other_contact = other_team.contacts.create(subscribed: true, person: contact.person)
            IceBreaker.call(other_contact)
          end

          context 'multiple teams' do
            context 'current team having multiple accounts' do
              before do
                account = create(:account, organization: team.organization)
                team.accounts << account
                GlacierBreaker.call(account)
              end

              it 'sends an email to each account on both teams' do
                expect {
                  subject.consider_answer(inquiry, message)
                }.to have_enqueued_job(ActionMailer::DeliveryJob)
                  .with { |mailer, mailer_method, *_args|
                       expect(mailer).to eq('NotificationMailer')
                       expect(mailer_method).to eq('contact_ready_for_review')
                     }.exactly(3).times
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
          let(:message) { create(:message, body: 'a') }

          it 'asks the next question' do
            expect(subject.survey).to receive(:ask)

            subject.consider_answer(inquiry, message)
          end

          it 'does not call ReadReceiptsCreator' do
            expect(ReadReceiptsCreator).not_to receive(:call)

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

              it 'does not send a message' do
                expect(subject.survey).not_to receive(:send_message)

                subject.consider_answer(Survey::LAST_QUESTION, second_message)
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

              context 'and another valid answer has already come in' do
                let(:first_message) { create(:message, body: 'A') }
                let(:second_message) { create(:message, body: 'A') }

                before do
                  first_surveyor = Surveyor.new(contact)
                  allow(first_surveyor.survey).to receive(:send_message)

                  first_surveyor.consider_answer(inquiry, first_message)
                end

                it 'does not raise an error' do
                  allow(subject.survey).to receive(:ask)

                  expect {
                    subject.consider_answer(inquiry, second_message)
                  }.not_to raise_error
                end

                it 'does not update the experience' do
                  allow(subject.survey).to receive(:ask)

                  expect {
                    subject.consider_answer(inquiry, message)
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
                  subject.consider_answer(inquiry, message)
                }.to change { candidacy.reload.availability }.to('hourly_pm')
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
                }.to change { candidacy.reload.certification }.to('cna')
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

          it 'calls ReadReceiptsCreator' do
            expect(ReadReceiptsCreator).to receive(:call)

            subject.consider_answer(inquiry, message)
          end
        end
      end
    end
  end
end
