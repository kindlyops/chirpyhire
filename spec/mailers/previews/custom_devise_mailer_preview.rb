class CustomDeviseMailerPreview < ActionMailer::Preview
  def invitation_instructions
    CustomDeviseMailer.invitation_instructions(Account.last, 'faketoken')
  end

  def reset_password_instructions
    CustomDeviseMailer.reset_password_instructions(Account.last, 'faketoken')
  end

  def password_change
    CustomDeviseMailer.password_change(Account.last)
  end
end
