# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  puts "Creating Organization"
  org = Organization.find_or_create_by!(
    name: "Happy Home Care",
    twilio_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
    twilio_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN"),
    phone_number: ENV.fetch("TEST_ORG_PHONE")
  )
  puts "Created Organization"

  FactoryGirl.create(:location, organization: org)
  puts "Created Location"

  puts "Creating User"
  user = User.find_or_create_by!(
   first_name: "Harry",
   last_name: "Whelchel",
   phone_number: ENV.fetch("DEV_PHONE"),
   organization: org
  )
  puts "Created User"

  puts "Creating Account"
  email = ENV.fetch("DEV_EMAIL")
  unless user.account.present?
    user.create_account!(password: "password", password_confirmation: "password", user: user, email: email, super_admin: true)
  end
  puts "Created Account"

  puts "Creating Referrer"
  Referrer.find_or_create_by(user: user)
  puts "Created Referrer"

  unless org.survey.present?
    bad_fit = Template.create(organization: org, name: "Bad Fit", body: "Thank you very much for your interest. Unfortunately, we don't "\
      "have a good fit for you at this time. If anything changes we will let you know.")
    welcome = Template.create(organization: org, name: "Welcome", body: "Hello this is Chirpyhire. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
    thank_you = Template.create(organization: org, name: "Thank You", body: "Thanks for your interest!")
    survey = org.create_survey(bad_fit: bad_fit, welcome: welcome, thank_you: thank_you)
  end

  unless org.survey.questions.present?
    yes_no_question = org.survey.questions.create(priority: 1, label: "Transportation", type: "YesNoQuestion", text: "Do you have reliable personal transportation?")
    address_question = org.survey.questions.create!(priority: 2, label: "Address", type: "AddressQuestion", text: "What is your address and zipcode?")
    address_question.create_address_question_option(distance: 20, latitude: 33.929966, longitude: -84.373931 )
    choice_question = org.survey.questions.create!(priority: 3, label: "Availability", type: "ChoiceQuestion", text: "What is your availability?",
      choice_question_options_attributes: [
        {text: "Live-in", letter: "a"}
        ])
    choice_question.choice_question_options.create(text: "Hourly", letter: "b")
    choice_question.choice_question_options.create(text: "Both", letter: "c")
    org.survey.questions.create!(priority: 4, label: "CNA License", type: "DocumentQuestion", text: "Please send us a photo of your CNA license.")
    puts "Created Profile Features"
  end

  unless org.rules.present?
    subscribe_rule_2 = org.rules.create!(trigger: "subscribe", actionable: org.survey.create_actionable)
    answer_rule = org.rules.create!(trigger: "answer", actionable: org.survey.actionable)
    screen_rule = org.rules.create!(trigger: "screen", actionable: thank_you.create_actionable)
    puts "Created Rules"
  end

  FactoryGirl.create_list(:candidate, 5, :with_address, status: "Bad Fit", organization: org)
  FactoryGirl.create_list(:candidate, 5, :with_address, status: "Qualified", organization: org)
  FactoryGirl.create_list(:candidate, 5, :with_address, status: "Potential", organization: org)
  FactoryGirl.create_list(:candidate, 5, :with_address, status: "Hired", organization: org)

  puts "Development specific seeding completed"
end

puts "Seed completed"

