unless Rails.env.production?
  Faker::Config.locale = 'en-US'
end
