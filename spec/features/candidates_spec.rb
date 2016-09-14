require 'rails_helper'

RSpec.feature "Candidates", type: :feature, js: true do
  let(:organization) { create(:organization, :with_subscription, phone_number: Faker::PhoneNumber.cell_phone) }
  let(:user) { create(:user, organization: organization) }
  let(:account) { create(:account, user: user) }

  before(:each) do
    login_as(account, scope: :account)
  end

  context "with candidates" do
    context "qualified candidates" do
      let(:qualified_stage) { account.organization.qualified_stage }
      let!(:candidate) { create(:candidate, organization: account.organization, stage: qualified_stage) }

      context "with other stages" do
        it "has stage drawer window hidden initially" do 
          visit candidates_path
          expect(first('li.stage > a')).to eq(nil)
        end
        it "can not move from qualified to qualified" do
          visit candidates_path
          first(".change-stage-button").click

          qualified_link_that_doesnt_exist = all("li.stage")[1].first("a")
          potential_link_that_does_exist = all("li.stage")[0].first("a")
          
          expect(qualified_link_that_doesnt_exist).to eq(nil)
          expect(potential_link_that_does_exist).not_to eq(nil)
        end
      end

      context "with candidate features" do
        let(:survey) { create(:survey, organization: account.organization) }
        context "with address persona feature" do
          let(:label) { "Address Category" }
          let!(:question) { create(:address_question, label: label, survey: survey) }

          context "with address" do
            let!(:address) { Address.new(create(:candidate_feature, :address, label: label, candidate: candidate)) }

            it "has a link to the address" do
              visit candidates_path
              expect(page).to have_text(address.formatted_address)
            end
          end
        end

        context "with document persona feature" do
          let(:label) { "Document Category" }
          let!(:question) { create(:question, label: label, survey: survey) }

          context "with document" do
            before(:each) do
              create(:candidate_feature, label: label, candidate: candidate, properties: { url0: "/path/to/image", child_class: "document" })
            end

            it "does not have a link to the document" do
              visit candidates_path
              expect(page).not_to have_selector("a[href='/path/to/image']")
              expect(page).not_to have_text("Document Category")
            end
          end
        end

        context "with choice persona feature" do
          let(:label) { "Choice Category" }
          let!(:question) { create(:question, :choice, label: label, survey: survey) }

          context "with choice" do
            before(:each) do
              create(:candidate_feature, label: label, candidate: candidate, properties: { choice_option: "Live-in", child_class: "choice" })
            end

            it "shows the choice" do
              visit candidates_path
              expect(page).to have_text("Choice Category")
              expect(page).to have_text("Live-in")
            end
          end
        end
      end

      context "viewing messages" do
        it "lets the account view the user's messages" do
          visit candidates_path

          click_button("user-#{candidate.user_id}-messages")
          expect(page).to have_text("Send")
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end
    end

    context "filtering" do
      let(:qualified_stage) { account.organization.qualified_stage }
      let(:potential_stage) { account.organization.potential_stage }
      let(:bad_fit_stage) { account.organization.bad_fit_stage }
      let(:hired_stage) { account.organization.hired_stage }
      context "default" do

        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, stage: [potential_stage, bad_fit_stage, hired_stage][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, stage: qualified_stage) }

        it "only shows Qualified candidates by default" do
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
            create(:candidate, stage: [potential_stage, hired_stage, qualified_stage][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, stage: bad_fit_stage) }

        it "only shows bad fit candidates" do
          visit candidates_path << "?stage_id=#{bad_fit_stage.id}"

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end

      context "Hired" do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, stage: [potential_stage, bad_fit_stage, qualified_stage][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, stage: hired_stage) }

        it "only shows Hired candidates" do
          visit candidates_path << "?stage_id=#{hired_stage.id}"

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
            create(:candidate, stage: [potential_stage, hired_stage, bad_fit_stage][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, stage: qualified_stage) }

        it "only shows qualified candidates" do
          visit candidates_path << "?stage_id=#{qualified_stage.id}"

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
            create(:candidate, stage: [bad_fit_stage, hired_stage, qualified_stage][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, stage: potential_stage) }

        it "only shows potential candidates" do
          visit candidates_path << "?stage_id=#{potential_stage.id}"

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end
    end

    context "more than one page of candidates" do
      let(:qualified_stage) { account.organization.qualified_stage }
      let(:users) { create_list(:user, 14, organization: account.organization) }
      let!(:candidates) do
        users.each do |user|
          create(:candidate, stage: qualified_stage, user: user)
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
