require 'rails_helper'

RSpec.describe InquisitorScheduler do
  include ActiveSupport::Testing::TimeHelpers

  let(:organization) { create(:organization, :with_owner) }
  let(:account) { organization.accounts.first }
  let(:search) { create(:search, :with_search_question, :with_search_lead, account: account) }
  let(:search_question) { search.search_questions.first }
  let(:search_lead) { search.search_leads.first }

  context "in organization time" do
    around(:each) do |example|
      Time.use_zone(organization.time_zone) { example.run }
    end

    describe "#call" do
      context "continuing the search" do
        let(:second_question) { create(:question, organization: organization) }
        let(:second_search_question) { search.search_questions.create(question: second_question, previous_question: search_question.question) }

        let(:inquisitor) { Inquisitor.new(search_lead: search_lead, search_question: second_search_question) }

        it "yields" do
          expect { |b|
            InquisitorScheduler.new(inquisitor).call(&b)
          }.to yield_control
        end
      end

      context "starting the search" do
        let(:inquisitor) { Inquisitor.new(search_lead: search_lead, search_question: search_question) }

        context "between 10 am and 8 pm today" do
          before(:each) do
            travel_to Time.current.at_beginning_of_day.advance(hours: 12)
          end

          it "yields" do
            expect { |b|
              InquisitorScheduler.new(inquisitor).call(&b)
            }.to yield_control
          end
        end

        context "before 10 am today" do
          before(:each) do
            travel_to Time.current.at_beginning_of_day.advance(hours: 6)
          end

          it "does not yield" do
            expect { |b|
              InquisitorScheduler.new(inquisitor).call(&b)
            }.not_to yield_control
          end

          it "creates a job to be performed after 10 am today" do
            ten_am = Time.current.at_beginning_of_day.advance(hours: 10)
            expect(InquisitorJob).to receive(:set).with(wait_until: ten_am + 1.minute).and_call_original

            InquisitorScheduler.new(inquisitor).call
          end
        end

        context "after 8 pm today" do
          before(:each) do
            travel_to Time.current.at_beginning_of_day.advance(hours: 22)
          end

          it "does not yield" do
            expect { |b|
              InquisitorScheduler.new(inquisitor).call(&b)
            }.not_to yield_control
          end

          it "creates a job to be performed after 10 am tomorrow" do
            ten_am = Time.current.at_beginning_of_day.advance(hours: 10)
            expect(InquisitorJob).to receive(:set).with(wait_until: ten_am.tomorrow + 1.minute).and_call_original

            InquisitorScheduler.new(inquisitor).call
          end
        end
      end
    end
  end
end
