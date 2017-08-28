class InternalMailerPreview < ActionMailer::Preview
  def health
    InternalMailer.health
  end
end
