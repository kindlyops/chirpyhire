module Features
  module InvitationHelpers
    def send_invitation_to(email)
      visit root_path
      find('#settingsDropdown', match: :first).trigger('click')
      find('#invite-admin', match: :first).trigger('click')

      fill_in 'Email', with: email
      click_button 'Invite'
    end
  end
end
