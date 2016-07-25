require 'rails_helper'

RSpec.describe Report::Weekly do
  let(:recipient) { create(:account) }
  let(:organization) { recipient.organization }
  let(:report) { Report::Weekly.new(recipient) }

  describe "#organization_name" do
    it "is the organization's name" do
      expect(report.organization_name).to eq(organization.name)
    end
  end

  describe "#humanized_week" do

    context "by default" do
      before(:each) do
        Timecop.freeze(Date.new(2016,07,21))
      end

      it "is today's date formatted" do
        expect(report.humanized_week).to eq("July 14th - July 20th")
      end
    end

    context "with date passed in" do
      let(:report) { Report::Weekly.new(recipient, date: Date.new(2016,01,21))}
      it "is the date formatted" do
        expect(report.humanized_week).to eq("January 14th - January 20th")
      end
    end
  end

  describe "#hired_count" do
    context "without candidates hired" do
      it "is zero" do
        expect(report.hired_count).to eq(0)
      end
    end

    context "with candidates hired" do
      context "in the past week" do
        let(:count) { rand(1..10) }
        let!(:candidates) { create_list(:candidate, count, status: "Hired", organization: organization, created_at: 4.days.ago) }
        it "is the count of candidates" do
          expect(report.hired_count).to eq(count)
        end
      end

      context "some in other weeks" do
        let(:count) { rand(1..10) }
        let!(:candidates) do
          count.times do
            create(:candidate, status: "Hired", organization: organization, created_at: 14.days.ago)
          end
        end

        it "is only the candidates hired in the past week" do
          create(:candidate, status: "Hired", organization: organization, created_at: Date.yesterday)
          expect(report.hired_count).to eq(1)
        end
      end
    end
  end

  describe "#qualified_count" do
    context "without candidates qualified" do
      it "is zero" do
        expect(report.qualified_count).to eq(0)
      end
    end

    context "with candidates qualified" do
      context "in the past week" do
        let(:count) { rand(1..10) }
        let!(:candidates) { create_list(:candidate, count, status: "Qualified", organization: organization, created_at: 4.days.ago) }
        it "is the count of candidates" do
          expect(report.qualified_count).to eq(count)
        end
      end

      context "some in other weeks" do
        let(:count) { rand(1..10) }
        let!(:candidates) do
          count.times do
            create(:candidate, status: "Qualified", organization: organization, created_at: 14.days.ago)
          end
        end

        it "is only the candidates qualified in the past week" do
          create(:candidate, status: "Qualified", organization: organization, created_at: Date.yesterday)
          expect(report.qualified_count).to eq(1)
        end
      end
    end
  end

  describe "#potential_count" do
    context "without candidates potential" do
      it "is zero" do
        expect(report.potential_count).to eq(0)
      end
    end

    context "with candidates potential" do
      context "in the past week" do
        let(:count) { rand(1..10) }
        let!(:candidates) { create_list(:candidate, count, status: "Potential", organization: organization, created_at: 4.days.ago) }
        it "is the count of candidates" do
          expect(report.potential_count).to eq(count)
        end
      end

      context "some in other weeks" do
        let(:count) { rand(1..10) }
        let!(:candidates) do
          count.times do
            create(:candidate, status: "Potential", organization: organization, created_at: 14.days.ago)
          end
        end

        it "is only the candidates potential in the past week" do
          create(:candidate, status: "Potential", organization: organization, created_at: Date.yesterday)
          expect(report.potential_count).to eq(1)
        end
      end
    end
  end

  describe "#bad_fit_count" do
    context "without candidates bad_fit" do
      it "is zero" do
        expect(report.bad_fit_count).to eq(0)
      end
    end

    context "with candidates bad_fit" do
      context "in the past week" do
        let(:count) { rand(1..10) }
        let!(:candidates) { create_list(:candidate, count, status: "Bad Fit", organization: organization, created_at: 4.days.ago) }
        it "is the count of candidates" do
          expect(report.bad_fit_count).to eq(count)
        end
      end

      context "some in other weeks" do
        let(:count) { rand(1..10) }
        let!(:candidates) do
          count.times do
            create(:candidate, status: "Bad Fit", organization: organization, created_at: 14.days.ago)
          end
        end

        it "is only the candidates bad_fit in the past week" do
          create(:candidate, status: "Bad Fit", organization: organization, created_at: Date.yesterday)
          expect(report.bad_fit_count).to eq(1)
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
