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
    twilio_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN")
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
    user.create_account(password: "password", password_confirmation: "password", role: Account.roles[:owner], user: user, email: email, super_admin: true)
  end
  puts "Created Account"

  puts "Creating Phone"
  Phone.find_or_create_by(number: ENV.fetch("TEST_ORG_PHONE"), organization: org)
  puts "Created Phone"

  puts "Creating Referrer"
  Referrer.find_or_create_by(user: user)
  puts "Created Referrer"

  puts "Creating Candidate"
  candidate = Candidate.find_or_create_by(user: user)
  puts "Created Candidate"

  unless org.templates.present?
    welcome = org.templates.create(name: "Welcome", body: "{{recipient.first_name}}, this is {{organization.name}}. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
    location = org.templates.create(name: "Location", body: "{{recipient.first_name}}, what is your street address and zipcode?")
    tb_test = org.templates.create(name: "TB Test", body: "If you have a current TB test please send a photo of it.")
    thank_you = org.templates.create(name: "Thank You", body: "Thanks for your interest!")
    puts "Created Templates"

    welcome_notice = welcome.create_notice
    location_question = location.create_question
    tb_question = tb_test.create_question(format: Question.formats[:image])
    thank_you_notice = thank_you.create_notice
    puts "Created Questions and Notices"
  end

  unless org.triggers.present?
    candidate_trigger = org.triggers.create(observable_type: "Candidate", operation: "subscribe")
    location_trigger = org.triggers.create(observable: location_question, operation: "answer")
    tb_trigger = org.triggers.create(observable: tb_question, operation: "answer")

    candidate_trigger.actions.create([{actionable: welcome_notice},{actionable: location_question}])
    location_trigger.actions.create(actionable: tb_question)
    tb_trigger.actions.create(actionable: thank_you_notice)
    puts "Created triggers and actions"
  end

  puts "Development specific seeding completed"
end

puts "Seed completed"

