module Features
  module InvitationHelpers
    def send_invitation_to(email)
      visit organizations_settings_people_invitation_new_path

      fill_in 'Email', with: email
      click_button 'Invite'
    end
  end
end
