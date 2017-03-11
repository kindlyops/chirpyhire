class CustomDeviseMailerPreview < ActionMailer::Preview
  def invitation_instructions
    CustomDeviseMailer.invitation_instructions(Account.last, "faketoken")
  end
end
