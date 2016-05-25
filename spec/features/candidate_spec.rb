require 'rails_helper'

RSpec.feature "Candidate" do
  include ActionView::Helpers::DateHelper

  let(:organization) { create(:organization, :with_account)}
  let(:account) { organization.accounts.first }
  let(:user) { create(:user, organization: organization) }
  let!(:candidate) { create(:candidate, :with_referral, user: user).decorate }

  background(:each) do
    login_as(account, scope: :account)
  end

  scenario "has a view of a candidate" do
    visit candidate_path(candidate)
    expect(page).to have_text(candidate.name)
    expect(page).to have_text(candidate.phone_number.phony_formatted)
    expect(page).to have_text(candidate.status)
  end

  context "with inquiries" do
    let(:question) { create(:template, :with_question).question }
    let(:inquiry) { question.perform(user) }
    let!(:inquiry_message) { inquiry.message.decorate }

    scenario "has the inquiries" do
      visit candidate_path(candidate)
      expect(page).to have_text(inquiry_message.sender_name)
      expect(page).to have_text(inquiry_message.body)
      expect(page).to have_text(time_ago_in_words(inquiry_message.created_at))
    end

    context "with answers" do
      let(:message) { FakeMessaging.new("foo", "bar").create(from: user.phone_number, to: organization.phone_number, body: Faker::Lorem.sentence, direction: "inbound") }
      let(:answer) { user.answer(inquiry, body: message.body, sid: message.sid) }
      let!(:answer_message) { answer.message.decorate }

      scenario "has the answer" do
        visit candidate_path(candidate)
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
    let(:notice) { create(:template, :with_notice).notice }
    let(:notification) { notice.perform(user) }
    let!(:notification_message) { notification.message.decorate }

    scenario "has the notifications" do
      visit candidate_path(candidate)
      expect(page).to have_text(notification_message.sender_name)
      expect(page).to have_text(notification_message.body)
      expect(page).to have_text(time_ago_in_words(notification_message.created_at))
    end
  end
end
