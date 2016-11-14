require 'rails_helper'

RSpec.describe Report::Daily do
  let(:organization) { create(:organization, :with_subscription, :with_account, :with_survey) }
  let(:recipient) { organization.accounts.first }
  let(:report) { Report::Daily.new(recipient) }

  describe '#organization_name' do
    it "is the organization's name" do
      expect(report.organization_name).to eq(organization.name)
    end
  end

  describe '#send?' do
    before(:each) do
      recipient.organization.subscription.update(state: 'active')
    end
    context 'when nothing has changed' do
      it 'does not send' do
        expect(report.send?).to eq(false)
      end
    end
    context 'when there are new non-understood responses to inquiries' do
      let(:question) { create(:choice_question, survey: organization.survey) }
      let(:inquiry_message) { create(:message, user: recipient.user, direction: 'outbound-api') }
      let(:inquiry) { create(:inquiry, question: question, message: inquiry_message) }
      let(:message) { create(:message, direction: 'inbound', body: question.choice_question_options.first.letter, user: recipient.user) }
      context 'that occured in the last day' do
        before(:each) do
          message
          NotUnderstoodHandler.notify(recipient.user, inquiry)
        end
        context 'without a candidate attached to the user' do
          it 'does not send' do
            expect(report.send?).to eq(false)
          end
        end
        context 'with a candidate attached to the user' do
          let!(:candidate) { create(:candidate, user: recipient.user) }
          it 'does not send' do
            expect(report.send?).to eq(true)
          end
          context 'with a later accepted valid answer' do
            let!(:answer) { create(:answer, inquiry: inquiry, message: message) }
            it 'sends' do
              expect(report.send?).to eq(true)
            end
          end
        end
      end
      context 'that occurred over a day ago' do
        it 'does not send' do
          message.update!(external_created_at: 2.days.ago)
          NotUnderstoodHandler.notify(recipient.user, inquiry)
          expect(report.send?).to eq(false)
        end
      end
    end
  end

  describe '#humanized_date' do
    context 'by default' do
      before(:each) do
        Timecop.freeze(Date.new(2016, 0o7, 21))
      end

      it "is today's date formatted" do
        expect(report.humanized_date).to eq('July 21st')
      end
    end

    context 'with date passed in' do
      let(:report) { Report::Daily.new(recipient, date: Date.new(2016, 0o1, 21)) }
      it 'is the date formatted' do
        expect(report.humanized_date).to eq('January 21st')
      end
    end
  end

  describe '#qualified_count' do
    context 'without candidates qualified' do
      it 'is zero' do
        expect(report.qualified_count).to eq(0)
      end
    end

    context 'with candidates qualified' do
      let(:count) { rand(1..10) }
      context 'on the date passed' do
        let!(:candidates) { create_list(:candidate, count, stage: organization.qualified_stage, organization: organization) }
        it 'is the count of candidates' do
          expect(report.qualified_count).to eq(count)
        end

        context 'on the date prior but within 24 hours' do
          let!(:users) { create_list(:user, count, :with_candidate, organization: organization, created_at: DateTime.current - 23.hours) }
          it 'is the count of candidates' do
            expect(report.qualified_count).to eq(count)
          end
        end
      end

      context 'some on other dates' do
        let(:count) { rand(1..10) }
        let!(:candidates) do
          count.times do
            date = (rand(10.days).seconds + 1.day.seconds).ago
            candidate = create(:candidate, stage: organization.qualified_stage, organization: organization, created_at: date)
            candidate.activities.update(created_at: date)
          end
        end

        it 'is only the candidates qualified on the date' do
          create(:candidate, stage: organization.qualified_stage, organization: organization)
          expect(report.qualified_count).to eq(1)
        end
      end
    end
  end

  describe '#recipient_first_name' do
    it "is the recipient's first name" do
      expect(report.recipient_first_name).to eq(recipient.first_name)
    end
  end
end
