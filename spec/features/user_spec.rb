require 'rails_helper'

RSpec.feature "User" do
  include ActionView::Helpers::DateHelper

  let(:organization) { create(:organization, :with_account)}
  let(:account) { organization.accounts.first }
  let(:user) { create(:user, organization: organization) }
  let!(:candidate) { create(:candidate, :with_referral, user: user) }

  background(:each) do
    login_as(account, scope: :account)
  end

  scenario "has a view of a user" do
    visit user_path(user)
    expect(page).to have_text(user.decorate.name)
    expect(page).to have_text(user.phone_number.phony_formatted)
    expect(page).to have_text(candidate.status)
  end

  context "with inquiries" do
    let(:user_feature) { create(:user_feature, user: user) }
    let(:inquiry) { user_feature.inquire }
    let!(:inquiry_message) { inquiry.message.decorate }

    scenario "has the inquiries" do
      visit user_path(user)
      expect(page).to have_text(inquiry_message.sender_name)
      expect(page).to have_text(inquiry_message.body)
      expect(page).to have_text(time_ago_in_words(inquiry_message.created_at))
    end

    context "with answers" do
      let(:message) { FakeMessaging.inbound_message(user, organization) }
      let(:answer) do
        AnswerHandler.call(user, inquiry, message.sid)
      end
      let!(:answer_message) { answer.message.decorate }

      scenario "has the answer" do
        visit user_path(user)
        expect(page).to have_text(inquiry_message.sender_name)
        expect(page).to have_text(inquiry_message.body)
        expect(page).to have_text(time_ago_in_words(inquiry_message.created_at))
        expect(page).to have_text(answer_message.sender_name)
        expect(page).to have_text(answer_message.body)
        expect(page).to have_text(time_ago_in_words(answer_message.created_at))
      end
    end
  end

  context "with notifications" do
    let(:template) { create(:template) }
    let(:notification) { template.perform(user) }
    let!(:notification_message) { notification.message.decorate }

    scenario "has the notifications" do
      visit user_path(user)
      expect(page).to have_text(notification_message.sender_name)
      expect(page).to have_text(notification_message.body)
      expect(page).to have_text(time_ago_in_words(notification_message.created_at))
    end
  end
end
