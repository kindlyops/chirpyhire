require 'rails_helper'

RSpec.feature "Candidates", type: :feature, js: true do
  let(:account) { create(:account) }

  before(:each) do
    login_as(account, scope: :account)
  end

  context "with candidates" do

    context "filtering" do
      context "default" do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, status: ["Potential", "Bad Fit", "Qualified"][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, status: "Screened") }

        it "only shows Screened candidates by default" do
          visit candidates_path

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end

      context "Bad Fit" do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, status: ["Potential", "Screened", "Qualified"][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, status: "Bad Fit") }

        it "only shows bad fit candidates" do
          visit candidates_path << "?status=Bad Fit"

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end

      context "Screened" do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, status: ["Potential", "Bad Fit", "Qualified"][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, status: "Screened") }

        it "only shows Screened candidates" do
          visit candidates_path << "?status=Screened"

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end

      context "Qualified" do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, status: ["Potential", "Screened", "Bad Fit"][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, status: "Qualified") }

        it "only shows qualified candidates" do
          visit candidates_path << "?status=Qualified"

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end

      context "Potential" do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, status: ["Bad Fit", "Screened", "Qualified"][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, status: "Potential") }

        it "only shows potential candidates" do
          visit candidates_path << "?status=Potential"

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end
    end

    context "more than one page of candidates" do
      let(:users) { create_list(:user, 7, organization: account.organization) }
      let!(:candidates) do
        users.each do |user|
          create(:candidate, status: "Screened", user: user)
        end
      end

      it "allows you to page to the next group of candidates" do
        visit candidates_path
        candidates[0..2].each do |candidate|
          expect(page).not_to have_text(candidate.phone_number.phony_formatted)
        end

        click_link('2')

        candidates[0..2].each do |candidate|
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end
    end
  end
end
