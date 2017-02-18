if Rails.env.development?
  Seeder.new.seed
  puts "Development specific seeding completed"
end

puts "Seed completed"
