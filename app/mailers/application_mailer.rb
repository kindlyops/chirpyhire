class ApplicationMailer < ActionMailer::Base
  default from: '"ChirpyHire" <notifications@chirpyhire.com>',
          reply_to: '"ChirpyHire" <hello@chirpyhire.com>'

  layout 'mailer'
  helper MailerHelper
  helper EmojiHelper
end
