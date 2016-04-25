module Features
  module InvitationHelpers
    def send_invitation_to(email)
      visit new_account_invitation_path

      fill_in "Email", with: email
      click_button "Invite"
    end
  end
end
