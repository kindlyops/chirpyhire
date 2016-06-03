# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  puts "Creating Organization"
  org = Organization.find_or_create_by(
    name: "chirpyhire",
    twilio_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
    twilio_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN"),
    phone_number: ENV.fetch("TEST_ORG_PHONE")
  )
  puts "Created Organization"

  puts "Creating User"
  user = User.find_or_create_by(
   first_name: "Harry",
   last_name: "Whelchel",
   phone_number: ENV.fetch("DEV_PHONE"),
   organization: org
  )
  puts "Created User"

  puts "Creating Account"
  email = ENV.fetch("DEV_EMAIL")
  unless user.account.present?
    user.create_account(password: "password", password_confirmation: "password", user: user, email: email, super_admin: true)
  end
  puts "Created Account"

  puts "Creating Referrer"
  Referrer.find_or_create_by(user: user)
  puts "Created Referrer"

  puts "Creating Candidate"
  candidate = Candidate.find_or_create_by(user: user)
  puts "Created Candidate"

  unless org.profile.present?
    profile = org.create_profile
    profile.features.create(format: "document", name: "TB Test")
    puts "Created Profile and Features"
  end

  unless org.templates.present?
    welcome = org.templates.create(name: "Welcome", body: "Hello this is {{organization.name}}. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
    thank_you = org.templates.create(name: "Thank You", body: "Thanks for your interest!")
    puts "Created Templates"
  end

  unless org.rules.present?
    subscribe_rule = org.rules.create(trigger: "subscribe", action: welcome)
    subscribe_rule_2 = org.rules.create(trigger: "subscribe", action: profile)
    answer_rule = org.rules.create(trigger: "answer", action: profile)
    screen_rule = org.rules.create(trigger: "screen", action: thank_you)
    puts "Created rules"
  end

  # unless user.tasks.present?
  #   raw_messages = Organization.first.send(:messaging_client).messages.list.select do |message|
  #     message.direction == "inbound"
  #   end

  #   messages = raw_messages.map do |message|
  #     MessageHandler.call(User.first, Messaging::Message.new(message))
  #   end

  #   20.times do |i|
  #     FactoryGirl.create(:task, user: User.first, taskable: messages[i])
  #   end
  # end

  puts "Development specific seeding completed"
end

puts "Seed completed"

