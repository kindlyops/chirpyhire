# frozen_string_literal: true
module Features
  module InvitationHelpers
    def send_invitation_to(email)
      visit root_path
      find('#desktop-settings', match: :first).trigger('click')
      click_link('Invite an Admin')

      fill_in 'Email', with: email
      click_button 'Invite'
    end
  end
end
