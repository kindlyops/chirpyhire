module Features
  module InvitationHelpers
    def send_invitation_to(email, name)
      visit organizations_settings_people_invitation_new_path

      fill_in 'Email', with: email
      fill_in 'Name', with: name
      click_button 'Invite'
    end
  end
end
