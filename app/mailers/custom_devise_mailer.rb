class CustomDeviseMailer < Devise::Mailer
  def subject_for(key)
    return super unless key.to_s == 'invitation_instructions'

    I18n.t(subject_key, invited_by: invitor)
  end

  private

  def subject_key
    'devise.mailer.invitation_instructions.subject'
  end

  def invitor
    return 'Someone' unless resource.invited_by

    resource.invited_by.first_name
  end
end
