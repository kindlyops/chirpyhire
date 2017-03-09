unless Rails.env.production?
  Seeder.new.seed
  puts "Development specific seeding completed"
end

puts "Seed completed"

