require 'rails_helper'

RSpec.feature "Candidates", type: :feature, js: true do
  let(:account) { create(:account) }

  before(:each) do
    login_as(account, scope: :account)
  end

  context "with candidates" do
    context "qualified candidates" do
      let!(:candidate) { create(:candidate, organization: account.organization, status: "Qualified") }

      it "lets the account call the candidate" do
        visit candidates_path << "?status=Qualified"
        call_button = find_button("call-#{candidate.user_id}")
        expect(call_button.present?).to eq(true)
      end
    end

    context "screened candidates" do
      let!(:candidate) { create(:candidate, organization: account.organization, status: "Screened") }

      context "with candidate features" do
        let(:candidate_persona) { account.organization.create_candidate_persona }
        context "with address persona feature" do
          let(:category) { create(:category, name: "Address Category") }
          let!(:persona_feature) { create(:persona_feature, :with_geofence, category: category, candidate_persona: candidate_persona) }

          context "without address" do
            it "has an empty state" do
              visit candidates_path
              expect(page).to have_text("No address found yet")
            end
          end

          context "with address" do
            let!(:address) { Address.new(create(:candidate_feature, :address, category: category, candidate: candidate)) }

            it "has a map of the address" do
              visit candidates_path
              expect(page).not_to have_text("No address found yet")
              expect(page).to have_text(address.formatted_address)
              expect(page).to have_selector(".map img")
            end

            it "allows the account to visit a Google Map of the address" do
              visit candidates_path
              new_window = window_opened_by { click_link(address.formatted_address) }

              page.within_window(new_window) do
                expect(current_url).to match(/google/)
              end
            end
          end
        end

        context "with document persona feature" do
          let(:category) { create(:category, name: "Document Category") }
          let!(:persona_feature) { create(:persona_feature, category: category, candidate_persona: candidate_persona) }

          context "with document" do
            before(:each) do
              create(:candidate_feature, category: category, candidate: candidate, properties: { url0: "/path/to/image", child_class: "document" })
            end

            it "has a link to the document" do
              visit candidates_path
              expect(page).to have_selector("a[href='/path/to/image']")
              expect(page).to have_text("Document Category")
            end
          end
        end

        context "with choice persona feature" do
          let(:category) { create(:category, name: "Choice Category") }
          let!(:persona_feature) { create(:persona_feature, :choice, category: category, candidate_persona: candidate_persona) }

          context "with choice" do
            before(:each) do
              create(:candidate_feature, category: category, candidate: candidate, properties: { choice_option: "Live-in", child_class: "choice" })
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

      context "marking as bad fit" do
        it "lets the account mark a candidate as bad fit" do
          visit candidates_path

          click_button("bad-fit")
          expect(page).to have_text("Nice! #{candidate.phone_number.phony_formatted} marked as Bad Fit")
        end
      end

      context "marking as qualified" do
        it "lets the account mark a candidate as qualified" do
          visit candidates_path

          click_button("qualified")
          expect(page).to have_text("Nice! #{candidate.phone_number.phony_formatted} marked as Qualified")
        end
      end
    end

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
