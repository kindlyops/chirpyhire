class ApplicationMailer < ActionMailer::Base
  default from: '"ChirpyHire" <notifications@chirpyhire.com>'
  layout 'mailer'
  helper MailerHelper
end
