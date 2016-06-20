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

  let(:message) { Faker::Lorem.sentence }
  scenario "can send a message to the user", js: true do
    visit user_path(user)
    click_link("Message")
    fill_in "body", with: message
    click_button "Send"

    card = find('.card')
    expect(card.find('.card-header').text).to eq(user.decorate.name)
    expect(card.find('.card-description').text).to include(message)
  end

  context "with inquiries" do
    let(:persona_feature) { create(:persona_feature, candidate_persona: organization.candidate_persona) }
    let(:candidate_feature) { create(:candidate_feature, persona_feature: persona_feature, user: user) }
    let(:inquiry) { candidate_feature.inquire }
    let!(:inquiry_activity) { inquiry.activities.first.decorate }

    scenario "has the inquiries" do
      visit user_path(user)
      expect(page).to have_text(inquiry_activity.owner.from)
      expect(page).to have_text(inquiry.body)
      expect(page).to have_text(time_ago_in_words(inquiry_activity.created_at))
    end

    context "with answers" do
      let(:message) { FakeMessaging.inbound_message(user, organization) }
      let(:answer) do
        AnswerHandler.call(user, inquiry, message.sid)
      end
      let!(:answer_activity) { answer.activities.first.decorate }

      scenario "has the answer" do
        visit user_path(user)
        expect(page).to have_text(inquiry_activity.owner.from)
        expect(page).to have_text(inquiry.body)
        expect(page).to have_text(time_ago_in_words(inquiry_activity.created_at))
        expect(page).to have_text(answer_activity.owner.from)
        expect(page).to have_text(answer.body)
        expect(page).to have_text(time_ago_in_words(answer_activity.created_at))
      end
    end
  end

  context "with notifications" do
    let(:template) { create(:template) }
    let(:notification) { template.perform(user) }
    let!(:notification_activity) { notification.activities.first.decorate }

    scenario "has the notifications" do
      visit user_path(user)
      expect(page).to have_text(notification_activity.owner.from)
      expect(page).to have_text(notification.body)
      expect(page).to have_text(time_ago_in_words(notification_activity.created_at))
    end
  end
end
