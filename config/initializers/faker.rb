unless Rails.env.development?
  Faker::Config.locale = 'en-US'
end
