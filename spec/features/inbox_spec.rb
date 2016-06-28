require 'rails_helper'

RSpec.feature "Inbox" do
  let(:organization) { create(:organization, :with_account)}
  let(:account) { organization.accounts.first }

  background(:each) do
    login_as(account, scope: :account)
  end

  context "viewing all tasks" do
    scenario "has a table of tasks" do
      visit inbox_path
      expect(page).to have_text("No task has been selected")
    end

    context "with tasks" do
      include ActionView::Helpers::DateHelper
      let(:user) { create(:user, organization: organization) }
      let(:candidate) { create(:candidate, user: user) }
      let!(:task) { candidate.create_activity(:screen, outstanding: true, owner: user).decorate }

      scenario "has the task information" do
        visit inbox_path
        expect(page).to have_text(task.body)
      end

      context "task has a chirp", js: true do
        let(:chirp) { create(:chirp, user: user) }
        let!(:task) { chirp.activities.last.decorate }

        it "has a form to send a message back" do
          visit inbox_path
          find(:xpath, "//li[@data-link]").click
          expect(page).to have_text("Send")
        end
      end

      scenario "each task leads to the task's page", js: true do
        visit inbox_path
        find(:xpath, "//li[@data-link]").click
        expect(page).to have_text(task.body)
        expect(page).to have_text("Review")
      end
    end
  end
end
