class CustomDeviseMailer < Devise::Mailer
  default from: '"ChirpyHire" <notifications@chirpyhire.com>'
  layout 'mailer'
  helper MailerHelper
  
  def subject_for(key)
    return super unless key.to_s == 'invitation_instructions'

    I18n.t(subject_key, invited_by: invitor)
  end

  private

  def subject_key
    'devise.mailer.invitation_instructions.subject'
  end

  def invitor
    return default_invitor unless resource.invited_by

    resource.invited_by.first_name
  end

  def default_invitor
    "A #{resource.organization.name} team member"
  end
end
