module Features
  module InvitationHelpers
    def send_invitation_to(email, name)
      visit new_account_invitation_path

      fill_in 'Email', with: email
      click_button 'Send Email Invitation'
    end
  end
end
