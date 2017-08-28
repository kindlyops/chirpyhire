class InternalMailerPreview < ActionMailer::Preview
  def health
    file = Rails.root.join('spec', 'support', 'fixtures', 'multiple.csv')
    InternalMailer.health(file.to_s)
  end
end
