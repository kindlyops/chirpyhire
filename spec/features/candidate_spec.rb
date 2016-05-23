require 'rails_helper'

RSpec.feature "Candidate" do
  include ActionView::Helpers::DateHelper

  let(:organization) { create(:organization, :with_account, :with_successful_phone)}
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

  context "with sent questions" do
    scenario "has the sent questions" do
      visit candidate_path(candidate)
      expect(page).to have_text(message.sender)
      expect(page).to have_text(message.body)
      expect(page).to have_text(time_ago_in_words(message.created_at))
    end

    # context "with replies" do
    #   scenario "has the replies" do
    #     visit candidate_path(candidate)

    #   end
    # end
  end

  # context "with notifications" do
  #   scenario "has the notifications" do
  #     visit candidate_path(candidate)

  #   end
  # end
end
