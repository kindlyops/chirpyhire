require 'rails_helper'

RSpec.feature "Conversations", type: :feature, js: true do
  let(:account) { create(:account) }

  before(:each) do
    login_as(account, scope: :account)
  end

  context "with conversations" do
    let(:user) { create(:user, organization: account.organization) }
    let!(:conversation) { create(:message, body: "Conversation Test Body", user: user) }

    it "allows you to view a specific conversation" do
      visit conversations_path
      click_link("conversation-#{conversation.id}")
      expect(page).to have_text("Send")
      expect(page).to have_text(user.phone_number.phony_formatted)
      expect(page).to have_text(conversation.body)
    end

    context "more than one page of conversations" do
      let(:users) { create_list(:user, 15, organization: account.organization) }
      let!(:conversations) do
        users.each_with_index do |user, index|
          create(:message, body: "Conversation - #{index}", user: user)
        end
      end

      it "allows you to page to the next group of conversations" do
        visit conversations_path
        users[8..15].each do |user|
          expect(page).not_to have_text(user.phone_number.phony_formatted)
          expect(page).not_to have_text(user.messages.last.body)
        end

        click_link('2')

        users[8..15].each do |user|
          expect(page).to have_text(user.phone_number.phony_formatted)
          expect(page).to have_text(user.messages.last.body)
        end
      end
    end
  end
end
