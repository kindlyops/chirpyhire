require 'rails_helper'

RSpec.feature "Referrers" do
  let(:organization) { create(:organization, :with_account, :with_successful_phone)}
  let(:account) { organization.accounts.first }

  background(:each) do
    login_as(account, scope: :account)
  end

  context "viewing all referrers" do
    scenario "has a table of referrers" do
      visit referrers_path
      expect(page).to have_text("Referrers")
      expect(page).to have_text("Name")
      expect(page).to have_text("Phone")
      expect(page).to have_text("Last Referral")
      expect(page).to have_text("Last Referred")
    end

    context "with referrers" do
      include ActionView::Helpers::DateHelper
      let(:user) { create(:user, organization: organization) }
      let!(:referrer) { create(:referrer, :with_referral, user: user).decorate }
      scenario "has the referrer information" do
        visit referrers_path
        expect(page).to have_text(referrer.name)
        expect(page).to have_text(referrer.phone_number.phony_formatted)
        expect(page).to have_text(referrer.last_referred_name)
        expect(page).to have_text("#{time_ago_in_words(referrer.last_referral_created_at)}")
      end
    end
  end
end
