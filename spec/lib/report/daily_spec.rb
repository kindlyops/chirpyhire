require 'rails_helper'

RSpec.describe Report::Daily do
  let(:recipient) { create(:account) }
  let(:organization) { recipient.organization }
  let(:report) { Report::Daily.new(recipient) }

  describe "#organization_name" do
    it "is the organization's name" do
      expect(report.organization_name).to eq(organization.name)
    end
  end

  describe "#humanized_date" do
    context "by default" do
      before(:each) do
        Timecop.freeze(Date.new(2016,07,21))
      end

      it "is today's date formatted" do
        expect(report.humanized_date).to eq("July 21st")
      end
    end

    context "with date passed in" do
      let(:report) { Report::Daily.new(recipient, date: Date.new(2016,01,21))}
      it "is the date formatted" do
        expect(report.humanized_date).to eq("January 21st")
      end
    end
  end

  describe "#screened_count" do
    context "without candidates screened" do
      it "is zero" do
        expect(report.screened_count).to eq(0)
      end
    end

    context "with candidates screened" do
      context "on the date passed" do
        let(:count) { rand(1..10) }
        let!(:candidates) { create_list(:candidate, count, status: "Screened", organization: organization) }
        it "is the count of candidates" do
          expect(report.screened_count).to eq(count)
        end
      end

      context "some on other dates" do
        let(:count) { rand(1..10) }
        let!(:candidates) do
          count.times do
            create(:candidate, status: "Screened", organization: organization, created_at: (rand(10.days).seconds + 1.day.seconds).ago)
          end
        end

        it "is only the candidates screened on the date" do
          create(:candidate, status: "Screened", organization: organization)
          expect(report.screened_count).to eq(1)
        end
      end
    end
  end

  describe "#recipient_first_name" do
    it "is the recipient's first name" do
      expect(report.recipient_first_name).to eq(recipient.first_name)
    end
  end
end
